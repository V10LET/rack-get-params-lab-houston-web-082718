class Application

  @@items = ["Apples","Carrots","Pears"]
  @@cart = []

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

# ------> Items GET request
    if req.path.match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end

# ------> Search GET request
    elsif req.path.match(/search/)
      search_term = req.params["q"]
      resp.write handle_search(search_term)

# ------> Add item to cart GET request
    elsif req.path.match(/add/)
      get = req.params["item"]
      if @@items.include?(get)
        @@cart << get
        resp.write "added #{get}"
      else
        resp.write "We don't have that item"
      end

# ------> Display cart GET request
    elsif req.path.match(/cart/)
      if @@cart == []
        resp.write "Your cart is empty"
      else
        @@cart.each { |item|
            resp.write "#{item}\n"
        }
      end

# ------> Display invalid GET request
    else
      resp.write "Path Not Found"
    end

    resp.finish
  end

  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end
end
