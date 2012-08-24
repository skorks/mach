require File.expand_path('../spec_helper', __FILE__)
require "base64"
require 'mach/signature'

describe Mach::Signature do
  let(:key) { "some_key" }
  let(:data) {"hello world"}

  describe "#to_s" do
    subject { Mach::Signature.new(key, data).to_s }

    context "produces a signature" do
      it { ->{subject}.should_not raise_error }
    end
    #this was to test ios integration and it seemed to work
    #context "testing123" do
      #let(:timestamp) {1344843814}
      #let(:nonce) {"PYVV2cPkVvVsB0Gi"}
      #let(:request_method) {"GET"}
      #let(:path) {"/contests/contest-20120191956?subject_path=%2Fcontests%2F20120191956"}
      #let(:host) {"staging.api.playupdev.com"}
      #let(:port) {80}

      #let(:data) do
        #Mach::NormalizedString.new(:timestamp => timestamp,
                                   #:nonce => nonce,
                                   #:request_method => request_method,
                                   #:path => path,
                                   #:host => host,
                                   #:port => port
                                  #).to_s
      #end

      #let(:key) { "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" }
      #it {subject.should == "YnHx40PpfjMaxtO+sxJvg2XtOF70L1zGlNad92dg8i4="}
    #end
  end

  describe "#matches?" do
    let(:signature) { Mach::Signature.new(key, data) }
    subject { signature.matches?(expected_signature) }


    context "when expected signature is invalid" do
      let(:expected_signature) { "abc123" }
      it {subject.should_not be_true}
    end
    context "when expected signature is valid" do
      let(:expected_signature) { '/wfbnU08rHnneh2Q4wSopDyULH43ePyuSyHMBc9nbnw=' }

      it {subject.should be_true}
    end
  end
end

