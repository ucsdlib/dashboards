require 'geckoboard'
require 'json'
require 'net/http'
require 'active_support/core_ext/hash'
require 'open-uri'
require 'openssl'

class Dashboard < ApplicationRecord
  validates :rdd_attribute, presence: true
  validates :rdd_value, presence: true
  
  def self.connect_geckoboard()
    geckoboard_api_key = Rails.application.credentials.geckoboard_api_key
    client = Geckoboard.client(geckoboard_api_key)
  end

  def self.chron
    auth_user = Rails.application.credentials.chron_auth_username
    auth_password = Rails.application.credentials.chron_auth_password
    uri = URI.parse("https://chron.ucsd.edu/ace-am/Status?count=20000&json=true")

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth(auth_user, auth_password)
    request.content_type = "application/json"
    http.use_ssl = true
    response = http.request(request).body
    chron_json = JSON.parse(response)
    chron_collections = chron_json["collections"]
    chron_files = 0
    chron_files_size = 0
    chron_active_files = 0
    chron_corrupt_files = 0
    lastSync_date =[]
    lastSync_date2 =[]

    chron_collections.each do |v|
        if v["totalFiles"]
           chron_files += v["totalFiles"].to_i
        end
        if v["totalSize"]
           chron_files_size += v["totalSize"].to_i
        end
        if v["activeFiles"]
           chron_active_files += v["activeFiles"].to_i
        end
        if v["corruptFiles"]
           chron_corrupt_files += v["corruptFiles"].to_i
        end
        if v["lastSync"]
           lastSync_date << DateTime.parse(v["lastSync"]).to_date
           lastSync_date2 << DateTime.parse(v["lastSync"])
        end
    end

    Dashboard.create(rdd_attribute: "chron_collections", rdd_value: chron_collections.count)
    Dashboard.create(rdd_attribute: "chron_files", rdd_value: chron_files)
    Dashboard.create(rdd_attribute: "chron_files_size", rdd_value: chron_files_size)
    Dashboard.create(rdd_attribute: "chron_active_files", rdd_value: chron_files_size)
    Dashboard.create(rdd_attribute: "chron_corrupt_files", rdd_value: chron_files_size)
  end

  def self.dlp
    dlp_complex_objects = 0
    complex_total_files = 0
    path = 'tmp/rdp/complex_list_dlp.txt'
    obj = Net::HTTP.get_response(URI.parse('http://lib-hydratail-prod.ucsd.edu:8983/solr/blacklight/select?q=%20unit_code_tesim:dlp&fl=id,%20component_count_isi&rows=20000')).body
    coll = Net::HTTP.get_response(URI.parse('http://lib-hydratail-prod.ucsd.edu:8983/solr/blacklight/select?q=%20unit_code_tesim:dlp+AND+type_tesim:Collection&fl=id,title_tesim&&rows=1000')).body
    json_obj = JSON.parse Hash.from_xml(obj).to_json
    json_coll = JSON.parse Hash.from_xml(coll).to_json
    byebug
    all_item = json_obj["response"]["result"]["doc"]
    dlp_objects = json_obj["response"]["result"]["numFound"]
    dlp_collections = json_coll["response"]["result"]["numFound"]

    all_item.each do |v|
      if v["int"]
        complex_total_files = complex_total_files + v["int"].to_i
        dlp_complex_objects +=1
      end
    end

    dlp_files = dlp_objects.to_i - dlp_complex_objects.to_i + complex_total_files.to_i
    Dashboard.create(rdd_attribute: "dlp_objects", rdd_value: dlp_objects)
    Dashboard.create(rdd_attribute: "dlp_complex_objects", rdd_value: dlp_complex_objects)
    Dashboard.create(rdd_attribute: "dlp_files", rdd_value: dlp_files)
    Dashboard.create(rdd_attribute: "dlp_collections", rdd_value: dlp_collections)
    
    client = connect_geckoboard
    push_to_dlp_dataset(client, dlp_objects, dlp_files)
  end

  def self.push_to_dlp_dataset(client, dlp_objects, dlp_files)
    dataset = client.datasets.find_or_create('test_test2', fields: [
    Geckoboard::DateTimeField.new(:timestamp, name: 'Time'),
    Geckoboard::NumberField.new(:dlp_objects, name: 'DLP_objects', optional: true),
    Geckoboard::NumberField.new(:dlp_files, name: 'DLP_files', optional: true)
    ], unique_by: [:timestamp])

    dataset.put([
      {
        timestamp: DateTime.now,
        dlp_objects: dlp_objects.to_i,
        dlp_files: dlp_files.to_i
      },
      {
        timestamp: DateTime.new(2017, 1, 3, 12, 0, 0),
        dlp_objects: 80900,
        dlp_files: 16400
      },
      {
        timestamp: DateTime.new(2017, 1, 4, 12, 0, 0),
        dlp_objects: 100900,
        dlp_files: 16400
      }
    ])
  end
end

