require "yaml"

module Phoner
  class Country < Struct.new(:name, :country_code, :char_2_code, :char_3_code, :area_code, :max_num_length)
    module All
      attr_accessor :all
    end
    extend All

    def all
      self.class.all
    end

    def self.load
      return self.all if !self.all.nil? && !self.all.empty?

      data_file = File.join("..","..","data", "phone", "countries.yml")
      data_path = File.expand_path(data_file, File.dirname(__FILE__))

      self.all = {}
      YAML.load(File.read(data_path)).each_pair do |key, c|
        self.all[key] = Country.new(
          c[:name],
          c[:country_code],
          c[:char_2_code],
          c[:char_3_code],
          c.fetch(:area_code, "[0-9][0-9][0-9]").freeze,
          c.fetch(:max_num_length, 8)
        )
      end

      self.all
    end

    def self.find_by_country_code(code)
      self.all[code]
    end

    def self.find_by_country_isocode(isocode)
      if country = self.all.detect{|c|c[1].char_3_code.downcase == isocode}
        country[1]
      end
    end

    def to_s
      name
    end

    def country_code_regexp
      @country_code_regexp ||= Regexp.new("^[+]#{country_code}")
    end
  end
end
