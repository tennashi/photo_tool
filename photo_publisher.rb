require 'rubygems'
require 'bundler/setup'

require 'date'
require 'pathname'
require 'kconv'
require 'optparse'
require 'exifr'
require 'RMagick'

require './Photo'

class PhotoPublisher < Tool
    def initialize
        super
        @event_date = nil
        @event_name = nil
        @pub_dir_name = nil # 公開するディレクトリ名
        @opts = OptionParser.new
        @photo_dir = PhotoDir.new
        @user = nil
        @password = nil
        initialize_parser
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
            error "The directory #{dir} does NOT exist!"
        end
        @photo_dir = dir
        info "Set photo directory as #{@photo_dir}."
    end

    def set_user(user)
        @user = user
        info "Set user as #{@user}."
    end

    def create_publish_dir
        if is_mode? :kusm_only then
            dir_path = Pathname.new("/var/www/htdocs/kusmonly/photos/#{@pub_dir_name}")
        else
            dir_path = Pathname.new("/var/www/htdocs/photos/#{@pub_dir_name}")
        end
        pub_dir = dir_path.mkdir
        info "Create publish directory as #{@pub_dir_name}"
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
        info "Set password"
    end

    def generate_thumbnail_html(photo, pre, post)
        html = ''
        html += <<-EOHtml
        <html lang="ja">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <meta name="Author" content="root">
            <meta name="robots" content="noindex,nofollow">
            <meta name="robots" content="noarchive">
            <meta name="generator" content="photo_publisher.rb ver1.0"> 
            <title>#{@event_name}</title>
            <style type="text/css">
            <!--
                BODY { font-style:osaka;color:#000080; }
                a:link { color:#269900; }
                a:visited { color:#269900; }
                A{text-decoration:none; font-weight:bold; }
                A:hover { color:#99FF33 }
            -->
            </STYLE>
        </head>
        <body>
        <center>
        <table><tr><td align="center">
        <img src=#{photo} >
        <br>
        <br>
        [ #{EXIFR::JPEG::new(photo).date_time.strftime("%m%d%H%M%S")} ]
        <br>&nbsp;
        </td></tr></table>
        <table width="80%">
            <tr>
            <td bgcolor="#ADD8E6" align="center">
                [ #{Pathname.new(pre).exist? ? "<A HERF=#{pre}>PRE</A>" : "PRE"} ] &nbsp;&nbsp;     [ <A HREF="../index.html">index</A> ] &nbsp;&nbsp;      [ <A HREF=#{Pathname.new(post).exist? ? "<A HREF=#{post}>NEXT</A> ]     </td>
            </tr>
        </table>
        </td></tr></table>
        </center>
        </body>
        </html>
        EOHtml
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


    def main
    end
end
