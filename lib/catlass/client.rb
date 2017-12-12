require 'rest-client'

module Catlass
  class Client

    CA_BASE_URI = 'https://manager.cloudautomator.com/api/v1'

    def initialize
      @headers = {
        content_type: :json,
        accept: :json,
        Authorization: "Bearer #{ENV['CA_API_KEY']}"
      }
    end

    def set_options(options)
      @options = options
    end

    def get_jobs(next_uri=nil)
      uri = "#{CA_BASE_URI}/jobs"
      uri = next_uri unless next_uri.nil?
      jobs = JSON.parse(RestClient.get(uri, headers=@headers).body)
      jobs['data'].concat(list_jobs(jobs['links']['next'])) if jobs['links'].has_key?('next')
      jobs['data']
    end

    def create_job(job)
      uri = "#{CA_BASE_URI}/jobs"
      RestClient.post(uri, job['attributes'].to_json, headers=@headers)
    end

    def update_job(job_id, job)
      uri = "#{CA_BASE_URI}/jobs/#{job_id}"
      RestClient.patch(uri, job['attributes'].to_json, headers=@headers)
    end

    def delete_job(job_id)
      uri = "#{CA_BASE_URI}/jobs/#{job_id}"
      RestClient.delete(uri, headers=@headers)
    end

  end
end
