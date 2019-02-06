require 'json'
require 'net/http'
require 'active_support/core_ext/hash'
require 'open-uri'
require 'openssl'

class Dashboard < ApplicationRecord
  validates :rdd_attribute, presence: true
  validates :rdd_value, presence: true

  def self.dlp
    complex_count = 0
    complex_total_files = 0
    path = 'tmp/rdp/complex_list_dlp.txt'
    obj = Net::HTTP.get_response(URI.parse('http://lib-hydratail-prod.ucsd.edu:8983/solr/blacklight/select?q=%20unit_code_tesim:dlp&fl=id,%20component_count_isi&rows=20000')).body
    coll = Net::HTTP.get_response(URI.parse('http://lib-hydratail-prod.ucsd.edu:8983/solr/blacklight/select?q=%20unit_code_tesim:dlp+AND+type_tesim:Collection&fl=id,title_tesim&&rows=1000')).body
    json_obj = JSON.parse Hash.from_xml(obj).to_json
    json_coll = JSON.parse Hash.from_xml(coll).to_json
    
    all_item = json_obj["response"]["result"]["doc"]
    all_item_count = json_obj["response"]["result"]["numFound"]
    all_coll_count = json_coll["response"]["result"]["numFound"]

    all_item.each do |v|
      if v["int"]
        complex_total_files = complex_total_files + v["int"].to_i
        complex_count +=1
      end
    end

    dlp_files = all_item_count.to_i - complex_count.to_i + complex_total_files.to_i
    Dashboard.create(rdd_attribute: "dlp_objects", rdd_value: all_item_count)
    Dashboard.create(rdd_attribute: "dlp_complex_objects", rdd_value: complex_count)
    Dashboard.create(rdd_attribute: "dlp_files", rdd_value: dlp_files)
    Dashboard.create(rdd_attribute: "dlp_collections", rdd_value: all_coll_count)
  end
end



