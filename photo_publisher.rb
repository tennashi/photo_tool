require 'rubygems'
require 'bundler/setup'

require 'date'
require 'pathname'
require 'kconv'
require 'optparse'
require 'exifr'
require 'RMagick'

class PhotoPublisher
    def initialize
        @photo_dir
        @photo_date
        @date
        @event_name
        @opts = OptionParser.new
        initialize_parser
    end

    def initialize_parser
        @opts.on('-d', '--directory=PHOTO_DIR', "set a photo directory") do |dir|
            @photo_dir = dir
        end
    end

    def get_photo_names(photo_dir)
        dir = Dir.open("photo_dir")
        photo_names = Array.new
        dir.each do |name|
            photo_names << name
        end
        return photo_names
    end

    def should_rotate?(photo)
    end

    def rotate(photo)
    end

    def resize(width, height, photo)
    end

    def get_date(photo_names)
        photos = Hash.new
        photo_names.each do |name|
            date = EXIFR::JPEG::new(name).date_time
            photos[name] = date.strftime("%m%d%H%M%S")
        end
        return photos
    end

    def sort_by_date(photos)
        sorted_photos = Hash.new
        sorted_photos = photos.sort_by {|key, value| value}
        return sorted_photos
    end

    def rename(sorted_photos)
        i = 1
        sorted_photos.each_key do |key|
            File.rename(key, sprintf("%10.4d", i) + ".jpg")
            i += 1
        end
    end

    def set_init(date, event_name)
    end

    def create_html()
    end

    def delete_exif()
    end

    def show_help()
    end

    def main
    end
end
