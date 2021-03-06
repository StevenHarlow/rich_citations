# Copyright (c) 2014 Public Library of Science

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'spec_helper'

describe Processors::ReferencesInfoCacheLoader do
  include Spec::ProcessorHelper

  before do
    PaperInfoCache.delete_all
  end

  it "should load info from the cache if it exists" do
    refs 'First'
    PaperInfoCache.create!(identifier:'doi:10.111/111', bibliographic:{uri_type: :doi, uri:'10.111/111', uri_source:'other', license:'cached' } )

    expect(IdentifierResolver).to receive(:resolve).and_return('ref-1' => { uri_type: :doi, uri:'10.111/111', uri_source:'test' })

    process

    expect(result[:references].first[:bibliographic]).to include(license:'cached')
  end

  it "Should do nothing if there was no cache record" do
    refs 'First'
    expect(IdentifierResolver).to receive(:resolve).and_return('ref-1' => { uri_type: :doi, uri:'10.111/111', uri_source:'test' })

    process

    expect(result[:references].first).to eq(uri_type: :doi, uri:'10.111/111', uri_source:'test', number:1, id:'ref-1')
  end

end
