require 'spec_helper'

describe ProgressBar::Components::Bar do
  context "when a new bar is created" do
    context "and no parameters are passed" do
      before { @progressbar = ProgressBar::Components::Bar.new }

      describe "#total" do
        it "returns the default total" do
          @progressbar.total.should eql ProgressBar::Components::Bar::DEFAULT_TOTAL
        end
      end

      describe "#progress_mark" do
        it "returns the default mark" do
          @progressbar.progress_mark.should eql ProgressBar::Components::Bar::DEFAULT_PROGRESS_MARK
        end
      end

      describe "#current" do
        it "returns the default beginning position" do
          @progressbar.current.should eql ProgressBar::Components::Bar::DEFAULT_BEGINNING_POSITION
        end
      end
    end

    context "and options are passed" do
      before { @progressbar = ProgressBar::Components::Bar.new(:total => 12, :progress_mark => "x", :beginning_position => 5) }

      describe "#total" do
        it "returns the overridden total" do
          @progressbar.total.should eql 12
        end
      end

      describe "#progress_mark" do
        it "returns the overridden mark" do
          @progressbar.progress_mark.should eql "x"
        end
      end

      describe "#current" do
        it "returns the overridden beginning position" do
          @progressbar.current.should eql 5
        end
      end
    end
  end

  context "when just begun" do
    before { @progressbar = ProgressBar::Components::Bar.new(:beginning_position => 0, :total => 50) }

    context "and the bar has been reversed" do
      before { @progressbar.reverse }

      it "displays the bar with no indication of progress" do
        @progressbar.to_s(100).should eql "                                                                                                    "
      end
    end

    describe "#percentage_completed" do
      it "calculates the amount" do
        @progressbar.percentage_completed.should eql 0
      end
    end

    describe "#to_s" do
      it "displays the bar with no indication of progress" do
        @progressbar.to_s(100).should eql "                                                                                                    "
      end
    end
  end

  context "when nothing has been completed" do
    before { @progressbar = ProgressBar::Components::Bar.new(:beginning_position => 0, :total => 50) }

    context "and the bar is incremented" do
      before { @progressbar.increment }

      it "adds to the current amount" do
        @progressbar.current.should eql 1
      end

      describe "#percentage_completed" do
        it "calculates the amount completed" do
          @progressbar.percentage_completed.should eql 2
        end
      end

      context "and the bar has been reversed" do
        before { @progressbar.reverse }

        describe "#to_s" do
          it "displays the bar with an indication of progress" do
            @progressbar.to_s(100).should eql "                                                                                                  oo"
          end
        end
      end

      describe "#to_s" do
        it "displays the bar with an indication of progress" do
          @progressbar.to_s(100).should eql "oo                                                                                                  "
        end
      end
    end

    describe "#percentage_completed" do
      it "is zero" do
        @progressbar.percentage_completed.should eql 0
      end
    end

    describe "#to_s" do
      it "displays the bar with no indication of progress" do
        @progressbar.to_s(100).should eql "                                                                                                    "
      end
    end
  end

  context "when a fraction of a percentage has been completed" do
    before { @progressbar = ProgressBar::Components::Bar.new(:beginning_position => 1, :total => 200) }

    describe "#percentage_completed" do
      it "always rounds down" do
        @progressbar.percentage_completed.should eql 0
      end
    end

    describe "#to_s" do
      it "displays the bar with no indication of progress" do
        @progressbar.to_s(100).should eql "                                                                                                    "
      end
    end
  end

  context "when completed" do
    before { @progressbar = ProgressBar::Components::Bar.new(:beginning_position => 50, :total => 50) }

    context "and the bar is incremented" do
      before { @progressbar.increment }

      it "doesn't increment past the total" do
        @progressbar.current.should eql 50
        @progressbar.percentage_completed.should eql 100
      end

      describe "#to_s" do
        it "displays the bar as 100% complete" do
          @progressbar.to_s(100).should eql "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
        end
      end
    end

    context "and the bar has been reversed" do
      before { @progressbar.reverse }

      describe "#to_s" do
        it "displays the bar with an indication of progress" do
          @progressbar.to_s(100).should eql "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
        end
      end
    end

    describe "#to_s" do
      it "displays the bar as 100% complete" do
        @progressbar.to_s(100).should eql "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
      end
    end
  end

  context "when attempting to set the bar's current value to be greater than the total" do
    describe "#new" do
      it "raises an error" do
        lambda{ ProgressBar::Components::Bar.new(:beginning_position => 11, :total => 10) }.should raise_error "You can't set the bar's current value to be greater than the total."
      end
    end
  end
end