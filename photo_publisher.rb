require 'rubygems'
require 'bundler/setup'

require 'date'
require 'pathname'
require 'kconv'
require 'optparse'
require 'exifr'
require 'RMagick'

require './Photo'

class PhotoPublisher
    def initialize
        @event_date = nil
        @event_name = nil
        @pub_dir_name = nil
        @opts = OptionParser.new
        @photo_dir = PhotoDir.new
        @user = nil
        @password = nil
        initialize_parser
        initialize_flags
    end

    def initialize_parser
        @opts.on('-d', '--directory=PHOTO_DIR', "set a photo directory") do |dir|
            set_photo_dir dir
        end
        @opts.on('-u', '--user=USERNAME', "set user") do |user|
            set_user user
        end
        # できたら photo_publisher -p <ENTER> -> password 入力待ち のようにしたい．
        @opts.on('-p', '--password=PASSWORD', "set password") do |password|
            set_password password
        end
        @opts.on('-k', '--kusm-only', TrueClass, "brouse by kusm only") do
            set_mode :kusm_only
        end
        @opts.on('-h', '--help', TrueClass, "show a help message") do
            enable_mode :help
        end
    end

    # Parse event_date and event_name: ./photo_publisher [OPTIONS] DATE NAME PUB_DIR_NAME
    def parse_options!(argv)
        @opts.order!(argv)
        if (!argv.empty?) then
            @event_date = argv.shift
        end
        @opts.order!(argv)
        if (!argv.empty?) then
            @event_name = argv.shift
        end
        @opts.order!(argv)
        if (!argv.empty?) then
            @pub_dir_name = argv.shift
    end

    def set_photo_dir(dir)
        dir = PhotoDir.new(dir)
        unless dir.exist? then
            STDERR.puts "The directory #{dir} does NOT exist!"
            exit 1
        end
        @photo_dir = dir
        STDOUT.puts "Set photo directory as #{@photo_dir}."
    end

    def set_user(user)
        @user = user
        STDOUT.puts "Set user as #{@user}."
    end

    def create_publish_dir
        if is_mode? :kusm_only then
            dir_path = Pathname.new("/var/www/htdocs/kusmonly/photos/#{@pub_dir_name}")
        else
            dir_path = Pathname.new("/var/www/htdocs/photos/#{@pub_dir_name}")
        end
        pub_dir = dir_path.mkdir
        STDOUT.puts "Create publish directory as #{@pub_dir_name}"
        [
            './html'
            './large',
            './small'
        ].each do |dir|
            (dir_path + dir).mkdir
        end
    end

    def set_password(password)
        @password = password
        STDOUT.puts "Set password"
    end

    def generate_photo_html
    end

    def generate_page_html
    end

    def generate_htaccess
    end

    def generate_htpasswd
        `htpasswd -c .htpasswd #{@user}`
    end

    def delete_exif
    end

    def need_root_or_exit
        if `id -u`.to_i != 0 then
            STDERR.puts 'need root privilege!'
            exit 1
        end
    end

    def initialize_flags
        @flags = {}
        disable_mode :kusm_only
        disable_mode :help
    end

    def disable_mode(type)
        set_mode type, false
    end

    def enable_mode(type)
        set_mode type, true
    end

    def set_mode(type, enabled)
        @flags[type] = enabled
        STDOUT.puts "#{enabled ? 'Enabled' : 'Disabled'} #{type} mode."
    end

    def is_mode?(type)
        @flags[type]
    end

    def main
    end
end
