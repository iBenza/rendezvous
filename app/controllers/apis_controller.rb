class ApisController < ApplicationController
  # TODO: not to use
  include ApplicationHelper

  def markdown_preview
    # TODO: not to use
    render text: MarkdownRenderer.new(params[:text]).render
  end

  # Receive file and upload to S3
  # @response [JSON]
  #  { "status": "OK",
  #    "files": [
  #      { "name": <file name>, "url": <link url>, "image": <image url>, "type": <file type>}, ...
  #     ]
  #  }
  def file_receiver
    uploads = []

    params[:files].each do |file|
      # Skip uploading if file ext is not listed.
      next unless file.original_filename =~ /\.(jpe?g|png|gif|pdf)\Z/

      hash_value = Digest::MD5.file(file.path)
      object_file_name = "#{hash_value}#{File.extname(file.original_filename)}"
      uploaded_file = UploadedFile.new(file: file.path, name: object_file_name)
      uploaded_file.save

      case file.original_filename
      when /\.(jpe?g|png|gif)\Z/
        uploads << { type: 'image', name: file.original_filename, image: uploaded_file.url }
      when /\.pdf\Z/
        if Settings.enable_pdf_uploading
          cover_image_name = "#{hash_value}-cover.png"
          pdf = Magick::ImageList.new(file.path + '[0]')
          cover_tmp = Rails.root.join('tmp', cover_image_name)
          pdf[0].write(cover_tmp)
          cover_file = UploadedFile.new(file: cover_tmp, name: cover_image_name)
          cover_file.save
          uploads << { type: 'slide', name: cover_image_name, url: uploaded_file.url,
                       image: cover_file.url }
        end
      end
    end

    render json: { status: 'OK', files: uploads, uploading_index: params[:uploading_index] }
  end

  def user_mention
    name_list = User.search(params[:q]).map { |user| "#{user.nickname}[#{user.name}]" }

    render json: name_list
  end
end
