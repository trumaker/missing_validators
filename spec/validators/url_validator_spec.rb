require 'spec_helper'

describe UrlValidator do
  let(:klass) do
    Class.new do
      include ActiveModel::Validations
      attr_accessor :url, :name
      validates :url, url: true
    end
  end

  subject(:model){ klass.new }

  it { should ensure_valid_url_format_of(:url) }
  it { should_not ensure_valid_url_format_of(:name) }

  it { should allow_value("http://example.com").for(:url) }
  it { should allow_value("http://FooBar.cOm").for(:url) }
  it { should allow_value("http://foo.bar.baz.com").for(:url) }
  it { should allow_value("http://123.com").for(:url) }
  it { should allow_value("http://www.example.ru").for(:url) }
  it { should allow_value("http://user-example.co.uk").for(:url) }
  it { should allow_value("https://example.com").for(:url) }
  it { should allow_value("http://example.org/").for(:url) }
  it { should allow_value("https://example.net/index.html").for(:url) }
  it { should allow_value("http://example.net/login.php").for(:url) }
  it { should allow_value("https://example.travel/").for(:url) }
  it { should allow_value("http://example.aero").for(:url) }
  it { should allow_value("http://example.aero?foo=bar").for(:url) }

  it { should_not allow_value("example").for(:url) }
  it { should_not allow_value("http://user_examplecom").for(:url) }
  it { should_not allow_value("http://user_example.com").for(:url) }
  it { should_not allow_value("http://user_example.a").for(:url) }
end