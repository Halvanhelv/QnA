module Gachibass
  def fun1
    1
  end

  def self.included(base)
    def fun2
      2

    end
  end

  def self.extended(base)
    def fun3
      3
    end
  end

end
