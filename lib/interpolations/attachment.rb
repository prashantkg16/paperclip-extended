module Paperclip
  class Attachment
    class << self
      alias_method :original_interpolations, :interpolations
    end
    
    def self.interpolations
      @interpolations ||= {
        :normalized_basename => lambda do |attachment, style| 
                                  normalize_basename(attachment.original_filename.gsub(File.extname(attachment.original_filename), ""))
                                end
      }.merge(original_interpolations)
    end
    
    def self.normalize_basename filename
      name, ext = File.basename(filename, File.extname(filename)), File.extname(filename)
      normalized = name.gsub(/[^A-Za-z0-9_-]/, '_')
      normalized = 'filename' if normalized.empty?
      normalized + ext
    end
  end
end