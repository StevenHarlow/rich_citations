require 'spec_helper'

describe PaperParser do
  include Spec::XmlBuilder

  describe "::is_failure?" do

    it "should consider nil to be a failure" do
      expect( PaperParser.is_failure?(nil) ).to be_truthy
    end

    it "should return a failure if no XML is provided" do
      result = PaperParser.parse_xml(nil)
      expect( PaperParser.is_failure?(result) ).to be_truthy
    end

    it "should normally return false" do
      xml = Nokogiri::XML('<root/>')
      result = PaperParser.parse_xml(xml)
      expect( PaperParser.is_failure?(result) ).to be_falsy
    end

  end

  describe "#parse" do

    def klass
      o = double(:processor, process:nil, cleanup:nil)
      k = double(:processor_klass, new:o, object:o, dependencies:nil)
    end

    before do
      @klasses = 4.times.map { klass }
      @parser = PaperParser.new(:some_xml)
      allow(PaperParser).to receive(:processor_classes).and_return(@klasses)
    end

    it "should instantiate each class" do
      @klasses.each { |k| expect(k).to receive(:new).and_return(k.object) }
      @parser.parse
    end

    it "should process each class" do
      @klasses.each { |k| expect(k.object).to receive(:process).ordered }
      @parser.parse
    end

    it "should cleanup each class after processing" do
      @klasses.each { |k| expect(k.object).to receive(:process).ordered }
      @klasses.each { |k| expect(k.object).to receive(:cleanup).ordered }
      @parser.parse
    end

    it "should include dependencies even if they are not specified" do
      klass = @klasses.first
      allow(klass).to receive(:dependencies).and_return( [@klasses.second, @klasses.third] )
      allow(PaperParser).to receive(:processor_classes).and_return([klass])

      expect(@klasses.second.object).to receive(:process).ordered
      expect(@klasses.third.object).to receive(:process).ordered
      expect(klass.object).to receive(:process).ordered
      @parser.parse
    end

    it "should order dependencies as specified" do
      allow(@klasses.first).to receive(:dependencies).and_return( [@klasses.second, @klasses.third] )

      expect(@klasses.second.object).to receive(:process).ordered
      expect(@klasses.third.object).to receive(:process).ordered
      expect(@klasses.first.object).to receive(:process).ordered
      expect(@klasses.fourth.object).to receive(:process).ordered
      @parser.parse
    end

    it "should load processors from the file system" do
      allow(PaperParser).to receive(:processor_classes).and_call_original
      expect(PaperParser.processor_classes).to include(Processors::References)
    end

  end

end
