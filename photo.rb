# -*- coding: utf-8; -*-

require 'rubygems'
require 'bundler/setup'

require 'date'
require 'kconv'
require 'exifr'
require 'RMagick'

# 写真を一括処理するクラス
class PhotoDir < Dir
    def initialize(dir_name = "./")
        Dir.chdir(dir_name)
        @photo_dir = open(dir_name)
        @names = grob(dir_name + "/*")
    end

#    # 名前を配列に保管
#    def get_name
#        names = Array.new
#        @photo_dir.each do |name|
#            names << name
#        end
#        return names
#    end

    # 日付を配列に保管
    def get_date
        dates = Array.new
        # 時間を 0324123515 のように取得する
        @names.each do |name|
            dates << EXIFR::JPEG::new(name).date_time.strftime("%m%d%H%M%S")
        end
        return dates
    end

    def get_hash_sorted_by_date!
        dates = @photo_dir.get_date
        # 2つの配列から Hash を作る
        photos = Hash[@names.zip dates]
        # Hash を 値でソート
        sorted = photos.sort_by {|key, value| value}
        return sorted
    end

    def rotate
        @names.each do |name|
            image = File.open(name).read
            m_image = Magick::Image.from_blob(image).shift
            m_image.auto_orient!
        end
    end

    def resize(height, width)
        @names.each do |name|
            image = File.open(name).read
            m_image = Magick::Image.from_blob(image).shift
            m_image.resize!(height, width)
        end
    end

    def rename_by_date!
        i = 1
        @photo_dir.get_hash_sorted_by_date!.each_key do |key|
            File.rename(key, sprintf("%10.4d", i) + ".jpg")
            i += 1
        end
    end
end

