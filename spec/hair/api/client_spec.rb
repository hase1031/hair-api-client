require 'spec_helper'

describe Hair::Api::Client do

  token = 'your token'

  before do
    Hair::Api::Client.configure do |options|
      options[:token] = token
    end
    WebMock.enable!
  end

  it 'has a version number' do
    expect(Hair::Api::Client::VERSION).not_to be nil
  end

  describe '#image_search' do

    path = '/image/search'
    query = 'query'

    context '200 status' do
      sample_response =
          {
              status: 200,
              message: '',
              data: [
                  {
                      image: {
                          id: 1,
                          key: 'key',
                          small: 'http://www.example.com',
                          medium: 'http://www.example.com',
                          large: 'http://www.example.com',
                      },
                      user: {
                          id: 1,
                          name: 'name',
                          aboutme: 'http://www.example.com',
                          icon_url: 'http://www.example.com',
                      },
                      url: 'http://www.example.com',
                  }
              ],
          }

      it 'returns 200 status' do
        query_string = URI.encode_www_form({query: query, token: token})
        WebMock.stub_request(:get, Hair::Api::Client::API_ENDPOINT + path + '?' + query_string).to_return(
            :body => JSON.generate(sample_response),
            :status => 200,
            :headers => {'Content-type' => ' application/json'}
        )
        res = Hair::Api::Client.image_search(query)
        images = res.images
        expect(images.length).to eq(sample_response[:data].length)
        expect(res.body['status']).to eq(sample_response[:status])
        expect(res.body['message']).to eq(sample_response[:message])
      end

      it 'use query params set by opts' do
        opts = {
            page: 2,
            limit: 10,
            sort: 'desc',
            sort_type: 'like',
        }
        query_string = URI.encode_www_form(opts.merge({query: query, token: token}))
        WebMock.stub_request(:get, Hair::Api::Client::API_ENDPOINT + path + '?' + query_string).to_return(
            :body => JSON.generate(sample_response),
            :status => 200,
            :headers => {'Content-type' => ' application/json'}
        )
        res = Hair::Api::Client.image_search(query, opts)
        images = res.images
        expect(images.length).to eq(sample_response[:data].length)
        expect(res.body['status']).to eq(sample_response[:status])
        expect(res.body['message']).to eq(sample_response[:message])
      end
    end

    context '500 status' do
      sample_response =
          {
              status: 500,
              message: 'Internal Server Error.',
              data: nil
          }

      it 'returns 500 status' do
        query_string = URI.encode_www_form({query: query, token: token})
        WebMock.stub_request(:get, Hair::Api::Client::API_ENDPOINT + path + '?' + query_string).to_return(
            :body => JSON.generate(sample_response),
            :status => 500,
            :headers => {'Content-type' => ' application/json'}
        )
        expect { Hair::Api::Client.image_search(query) }.to raise_error(Hair::Api::RequestError)
      end
    end
  end

  describe '#record' do

    path = '/record'

    context '200 status' do
      sample_response =
          {
              status: 200,
              message: 'OK',
          }
      it 'returns 200 status' do
        WebMock.stub_request(:post, Hair::Api::Client::API_ENDPOINT + path).to_return(
            :body => JSON.generate(sample_response),
            :status => 200,
            :headers => {'Content-type' => ' application/json'}
        )
        res = Hair::Api::Client.record('hiybkjtvqm', 'title', 'https://www.exaple.com/', Time.now)
        expect(res.body['status']).to eq(sample_response[:status])
        expect(res.body['message']).to eq(sample_response[:message])
      end
    end

    context '500 status' do
      sample_response =
          {
              status: 500,
              message: 'Internal Server Error.',
          }
      it 'returns 500 status' do
        WebMock.stub_request(:post, Hair::Api::Client::API_ENDPOINT + path).to_return(
            :body => JSON.generate(sample_response),
            :status => 500,
            :headers => {'Content-type' => ' application/json'}
        )
        expect { Hair::Api::Client.record('hiybkjtvqm', 'title', 'https://www.exaple.com/', Time.now) }.to raise_error(Hair::Api::RequestError)
      end
    end
  end

end
