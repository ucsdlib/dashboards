class Dashboard < ApplicationRecord

  validates :rdd_attribute, presence: true
  validates :rdd_value, presence: true


  def self_dlp
    complex_count = 0
    complex_total_objects = 0
    path = 'tmp/rdp/complex_list_dlp.txt'
    s = Net::HTTP.get_response(URI.parse('http://lib-hydratail-prod.ucsd.edu:8983/solr/blacklight/select?q=%20unit_code_tesim:dlp&fl=id,%20component_count_isi&rows=20000')).body
    json_re = Hash.from_xml(s).to_json
    h = JSON.parse json_re
    all = h["response"]["result"]["doc"]
    all_item_count = h["response"]["result"]["numFound"]

    File.open(path, 'w') do |f|
      all.each do |v|
        if v["int"]
          f.write(v["int"]+"\n") 
          complex_total_objects = complex_total_objects + v["int"].to_i
          complex_count +=1
        end
      end
      f.write("Total object count for rdp is " + all_item_count.to_s + "\n")
      f.write("Total file count for complex objexts is " + complex_total_objects.to_s + "\n")
      f.write("Total count for complex objexts is " + complex_count.to_s+ "\n")
      total_dlp_file = all_item_count.to_i - complex_count.to_i + complex_total_objects.to_i 
      f.write("Total dlp file count is " + total_dlp_file.to_s  )
      f.close
    end
    complex_total_objects.to_s
  end
end
