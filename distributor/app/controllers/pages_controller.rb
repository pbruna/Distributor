class PagesController < HighVoltage::PagesController
  
  skip_before_filter :authenticate_user!
  layout false

  
end
