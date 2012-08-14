require File.expand_path('../spec_helper', __FILE__)
require 'mach/normalized_string'

describe Mach::NormalizedString do
  let(:timestamp) {1344824119}
  let(:nonce) {"abc123"}
  let(:request_method) {"GET"}
  let(:path) {"/blah?yadda=5&foo=bar"}
  let(:host) {"blah.com"}
  let(:port) {80}
  let(:ext) {"hello"}

  let(:normalized_string) do
    Mach::NormalizedString.new(:timestamp => timestamp,
                               :nonce => nonce,
                               :request_method => request_method,
                               :path => path,
                               :host => host,
                               :port => port,
                               :ext => ext
                              )
  end

  describe "#to_s" do
    subject { normalized_string.to_s }
    context "when all compenents present" do
      it { subject.should == "#{timestamp}\n#{nonce}\n#{request_method}\n#{path}\n#{host}\n#{port}\n#{ext}" }
    end
    context "when no ext" do
      let(:ext) {nil}
      it { subject.should == "#{timestamp}\n#{nonce}\n#{request_method}\n#{path}\n#{host}\n#{port}\n\n" }
    end
  end
end
