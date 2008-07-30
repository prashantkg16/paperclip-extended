module Paperclip
  class Thumbnail
    def initialize file, target_geometry, format = nil, commands = nil, whiny_thumbnails = true
      @file             = file
      @crop             = target_geometry[-1,1] == '#'
      @target_geometry  = Geometry.parse target_geometry
      @current_geometry = Geometry.from_file file
      @whiny_thumbnails = whiny_thumbnails

      @current_format   = File.extname(@file.path)
      @basename         = File.basename(@file.path, @current_format)
      
      @commands = commands
      
      @format = format
    end

    def self.make file, dimensions, format = nil, commands = nil, whiny_thumbnails = true
      new(file, dimensions, format, commands, whiny_thumbnails).make
    end

    def transformation_command
      scale, crop = @current_geometry.transformation_to(@target_geometry, crop?)
      trans = "-scale \"#{scale}\""
      trans << " -crop \"#{crop}\" +repage" if crop
      trans << " #{@commands}" unless @commands.nil?
      trans
    end
  end
end