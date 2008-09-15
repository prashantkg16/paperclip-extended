module Paperclip
  class Attachment
    alias original_initialize initialize
    
    def initialize name, instance, options = {}
      @commands = options[:commands] ||= nil
      
      original_initialize name, instance, options
    end
    
    def post_process
      return if @queued_for_write[:original].nil?
      @styles.each do |name, args|        
        begin
          dimensions, format = args
          commands = @commands[name] ||= nil unless @commands.nil?
          @queued_for_write[name] = Thumbnail.make(@queued_for_write[:original], 
                                                   dimensions,
                                                   format, 
                                                   commands,
                                                   @whiny_thumnails)
        rescue PaperclipError => e
          @errors << e.message if @whiny_thumbnails
        end
      end
    end
  end
end