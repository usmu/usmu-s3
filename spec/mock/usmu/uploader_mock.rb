
module Usmu
  class UploaderMock
    attr_reader :diffs

    def push(diffs)
      @diffs = diffs
    end
  end
end
