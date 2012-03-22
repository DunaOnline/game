module FieldsHelper

  def oznaceni(field)
    field.pos_x.round.to_s+"-"+field.pos_y.round.to_s
  end
end
