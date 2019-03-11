require 'pry'

class Application

  @@items = []
  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    if valid?(req)
      if contained?(req)
        resp.write "#{Item.find_by_name(get_item(req)).price}"
      else
        resp.write "Item not found"
        resp.status = 400
      end
    else
      resp.write "Route not found"
      resp.status = 404
    end

    resp.finish
  end

  def valid?(req)
    !!req.path.match(/items/)
  end

  def contained?(req)
    item_name = get_item(req)
    Item.find_by_name(item_name).class == Item
  end

  def get_item(req)
    req.path.split("/items/").last
  end

end
