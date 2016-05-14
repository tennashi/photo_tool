# -*- coding: utf-8; -*-

require 'rubygems'
require 'bundler/setup'

require 'date'
require 'exifr'
require 'RMagick'

# 写真を一括処理するクラス
class PhotoDir < Pathname
    def initialize(dir_name = ".")
        super(dir_name)
        @dir_name = dir_name
        @names = Dir.glob(dir_name + "/*")
        @dates = self.get_date #配列
    end

    # 日付を配列に保管(privateで良い)
    def get_date
        dates = Array.new
        # 時間を 0324123515 のように取得する
        @names.each do |name|
            dates << EXIFR::JPEG::new(name).date_time.strftime("%m%d%H%M%S")
        end
        return dates
    end

    # privateで良い
    def get_hash_sorted_by_date!
        dates = @photo_dir.get_date
        # 2つの配列から Hash を作る
        photos = Hash[@names.zip dates]
        # Hash を 値でソート
        sorted = photos.sort_by {|key, value| value}
        return sorted
    end

    #要テスト
    def rotate
        @names.each do |name|
            image = File.open(name).read
            m_image = Magick::Image.from_blob(image).shift
            m_image.auto_orient!
        end
    end

    #要テスト
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

