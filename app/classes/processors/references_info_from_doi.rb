require 'uri'

module Processors
  class ReferencesInfoFromDoi < Base
    include Helpers

    def process
      references_for_type(:doi).each do |ref|
        next if ref[:info].try(:[], :type)

        doi = ref[:id]
        get_doi_info(doi, ref) if doi
      end
    end

    def self.dependencies
      ReferencesInfoCacheLoader
    end

    protected

    # cf http://www.crosscite.org/cn/
    # This API always does a redirect. If we can guess the source ebfore hand we could optimize slightly
    # see Pivotal #72716068

    API_URL = "http://dx.doi.org/"

    def get_doi_info(doi, ref)
      result = get_result(doi)
      result = result.except(:id, :id_type, :ref_source, :score)
      ref[:info].merge!(result)
    end

    def get_result(doi)
      url  = API_URL + URI.encode_www_form_component(doi)
      json = HttpUtilities.get(url, 'application/citeproc+json')
      JSON.parse(json, symbolize_names:true)
    end

  end
end