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
      filename.gsub(/[^A-Za-z0-9_-]/, '_')
    end
  end
end