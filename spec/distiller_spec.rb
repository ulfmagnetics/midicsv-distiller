require 'spec_helper'
require './distiller'

describe Distiller do
  context "given a CSV generated by midicsv" do
    let(:csv) { File.read('spec/fixtures/midi.csv') }
    let(:distiller) { Distiller.new(csv) }

    describe "#rows" do
      let(:options) { {} }

      subject { distiller.rows(options) }

      it "returns an array containing just the 'note on' events" do
        subject.class.should eq(Array)
        subject.size.should eq(12)
      end

      context "for default options" do
        it "has rows that contain start time and note number" do
          subject[0].should eq([0, 71])
          subject[1].should eq([48, 61])
        end
      end  

      context "when a root note is specified" do
        let(:options) { { root_note: 60 } }

        it "has rows that contain start time and offset from root" do
          subject[0].should eq([0, 11])
          subject[1].should eq([48, 1])
        end
      end

      context "when ticks_per_unit is specified" do
        let(:options) { { ticks_per_unit: 24 } }

        it "converts start times correctly" do
          subject[0][0].should eq(0)
          subject[1][0].should eq(2)
        end
      end
    end
  end
end