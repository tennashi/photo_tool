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
        @date
        @event_name
        @opts = OptionParser.new
        initialize_parser
    end

    def initialize_parser
        @opts.on('-d', '--directory=PHOTO_DIR', "set a photo directory") do |dir|
        end
        @opts.on('-h', '--help', TrueClass, "show a help message") do
        end
        @opts.on('-u', '--user', "set user") do
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
