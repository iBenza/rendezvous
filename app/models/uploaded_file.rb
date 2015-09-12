require 'fileutils'

class UploadedFile
  SUB_DIRECTORY = 'uploads'.freeze

  attr_reader :hash, :name

  def initialize(file:, name:)
    @uploaded_path = file
    @hash = Digest::MD5.file(file)
    @name = name || @hash.to_s + File.extname(file)
  end

  def url
    File.join('/', SUB_DIRECTORY, @name).to_s
  end

  def save
    FileUtils.copy(@uploaded_path, Rails.root.join('public', SUB_DIRECTORY, @name))
  end
end
