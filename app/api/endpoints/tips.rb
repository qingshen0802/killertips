module Endpoints
  class Tips < Grape::API

    resource :tips do

      # Tips API test
      # /api/v1/tips/ping
      # results  'tips endpoints'
      get :ping do
        { :ping => 'tips endpoints' }
      end

      # Get all tips
      # GET: /api/v1/tips
      #   Parameters accepted
      #     token         String *
      #     category_id   String
      #     favourite     Boolean
      #     unread        Boolean
      #     pack_id       String
      #     page_number   Integer
      #     per_page      Integer default 15
      #   Results
      #     {status: 1, data: {id, title, description, photo, category, pack}}
      get do
        user = User.find_by_token params[:token]
        if user.present?
          category  = params[:category_id]
          favourite = params[:favourite]
          unread    = params[:unread]
          pack_id = params[:pack_id]
          page_number = params[:page_number].present? ? params[:page_number].to_i : 1
          per_page = params[:per_page].present? ? params[:per_page].to_i : 15
          # tips = Tip.all.paginate(page: page_number, per_page: per_page).map{|t| t.info_by_json(user)}
          tips = user.purchased_tips.paginate(page: page_number, per_page: per_page).map{|t| t.info_by_json(user)}
          if category.present?
            category = Category.find(category)
            tips = category.tips.paginate(page: page_number, per_page: per_page).map{|t| t.info_by_json(user)}
          elsif favourite.present?
            tips = user.favourites.where(favourite: favourite).paginate(page: page_number, per_page: per_page).map{|f| f.tip_by_json}
          elsif unread.present?
            if unread == 'false'
              tips = user.read_tips(page_number).map{|t| t.info_by_json(user)}
            else
              tips = user.unread_tips(page_number, per_page).map{|t| t.info_by_json(user)}
            end
          elsif pack_id.present?
            pack = Pack.find(pack_id)
            tips = pack.tips.paginate(page: page_number, per_page: per_page).map{|t| t.info_by_json(user)}
          end
          {status: 1, data: tips}
        else
          {status: 0, data: "Please sign in"}
        end
      end

      # Find Tips by name
      # GET: /api/v1/tips/find
      #   Parameters accepted
      #     token         String *
      #     key           String *
      #     page_number   Integer default 1
      #     per_page      Integer default 15
      #   Results
      #     {status: 1, data: {id, title, description, photo, category, pack}}
      get :find do
        user = User.find_by_token params[:token]
        key = params[:key]
        page_number = params[:page_number].present? ? params[:page_number].to_i : 1
        per_page = params[:per_page].present? ? params[:per_page].to_i : 15
        if user.present?
          # tips = user.purchased_tips.any_of({title: /#{key}/}, {description: /#{key}/}).paginate(page: page_number, per_page: per_page)
          tip_ids = user.purchased_tips.map{|t| t.id.to_s}
          tips = Tip.where(id: { '$in': tip_ids })
          tips = tips.any_of({title: /^.*#{key}.*$/i}, {description: /^.*#{key}.*$/i}, {content: /^.*#{key}.*$/i}).paginate(page: page_number, per_page: per_page)
          {status: 1, data: tips.map{|t| t.info_by_json(user)}}
        else
          {status: 0, data: "Please sign in"}
        end
      end

      # Get all categories
      # GET: /api/v1/tips/categories
      #   Parameters accepted
      #     token         String *
      #   Results
      #     {status: 1, data: {id:category.id, name:category.name}}
      get :categories do
        user = User.find_by_token params[:token]
        if user.present?
          {status: 1, data: Category.all.map{|c| c.info_by_json}}
        else
          {status: 0, data: "Please sign in"}
        end
      end

      # Get Tip Content
      # GET: /api/v1/tips/tip_content
      #   Parameters accepted
      #     token         String *
      #     tip_id        String
      #   Results
      #     {status: 1, data: {id:tip.id, content:tip.content}}

      get :tip_content do
        user = User.find_by_token params[:token]
        if user.present?
          tip = Tip.find(params[:tip_id])
          {status: 1, data: {tip_id:tip.id.to_s, content:tip.content}}
        else
          {status: 0, data: "Please sign in"}
        end
      end


    end
  end
end
