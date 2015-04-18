require "passphrase"
require "optparse"

module Passphrase
  RSpec.describe CLI, "implements the command line interface" do
    before do
      @saved_stdout = $stdout
      $stdout = StringIO.new
    end

    after(:each) do
      $stdout = @saved_stdout
    end

    it "responds to class method parse() with one argument" do
      expect(CLI).to respond_to(:parse).with(1).argument
    end

    it "does not respond to class method display_languages() (private)" do
      expect(CLI).not_to respond_to(:display_languages)
    end

    it "does not respond to class method validate_number_of_words() (private)" do
      expect(CLI).not_to respond_to(:validate_number_of_words)
    end

    it "does not respond to class method print_out() (private)" do
      expect(CLI).not_to respond_to(:print_out)
    end

    it "does not respond to class method handle_error() (private)" do
      expect(CLI).not_to respond_to(:handle_error)
    end

    it "exits when option -l is supplied" do
      expect { CLI.parse(["-l"]) }.to raise_error(SystemExit)
    end

    it "does not emit an error when option -n 3 is supplied" do
      expect(CLI).not_to receive(:handle_error)
      CLI.parse(["-n", "3"])
    end

    it "does not emit an error when option -p is supplied" do
      expect(CLI).not_to receive(:handle_error)
      CLI.parse(["-p"])
    end

    it "does not emit an error when option -r is supplied" do
      expect(CLI).not_to receive(:handle_error)
      CLI.parse(["-r"])
    end

    it "exits when option -h is supplied" do
      expect { CLI.parse(["-h"]) }.to raise_error(SystemExit)
    end

    it "exits when option -v is supplied" do
      expect { CLI.parse(["-v"]) }.to raise_error(SystemExit)
    end

    it "emits an error when an invalid option is supplied" do
      # For some reason, :handle_error doesn't need to be stubbed
      expect(CLI).to receive(:handle_error)
        .with(kind_of(OptionParser::InvalidOption))
      invalid_option = ["-x"]
      CLI.parse(invalid_option)
    end

    it "emits an error when a mandatory argument is missing" do
      # For some reason, :handle_error doesn't need to be stubbed
      expect(CLI).to receive(:handle_error).twice
        .with(kind_of(OptionParser::MissingArgument))
      [["-n"], ["--num-words"]].each { |bad_option| CLI.parse(bad_option) }
    end

    it "emits an error when the number of words is out of range" do
      under_range = (Default.number_range.min - 1).to_s
      over_range = (Default.number_range.max + 1).to_s
      # For some reason, :handle_error doesn't need to be stubbed
      expect(CLI).to receive(:handle_error).exactly(4).times
        .with(kind_of(RuntimeError))
      ["-n", "--num-words"].each do |opt|
        [under_range, over_range].each do |arg|
          bad_option = [opt, arg]
          CLI.parse(bad_option)
        end
      end
    end
  end
end
