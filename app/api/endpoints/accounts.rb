module Endpoints
  class Accounts < Grape::API

    resource :accounts do

      # Accounts API test
      # /api/v1/accounts/ping
      # results  'gwangming'
      get :ping do
        { :ping => 'gwangming' }
      end

      # Set device token
      # POST: /api/v1/accounts/set_device
      #   Parameters accepted
      #     token         String *
      #     device_token  String *
      #   Results
      #     {status: 1, data: set device_token}
      post :set_device do
        user = User.find_by_token params[:token]
        if user.present?
          user.update(device_token: params[:device_token])
          {status: 1, data: "Set device_token"}
        else
          {status: 0, data: "Please sign in"}
        end
      end

      # Set Favourite
      # POST: /api/v1/accounts/set_favourite
      #   Parameters accepted
      #     token         String *
      #     tip_id        String *
      #     favourite     Boolean *
      #   Results
      #     {status: 1, data: set favourite}
      post :set_favourite do
        user = User.find_by_token params[:token]
        if user.present?
          if Tip.where(id: params[:tip_id]).count > 0
            Favourite.find_or_create_by(user_id:user.id, tip_id:params[:tip_id]).update(favourite: params[:favourite])
            # Favourite.create(user:user, tip_id: params[:tip_id], favourite: params[:favourite])
            {status: 1, data: "Set favourite"}
          else
            {status: 0, data: "Can't find this tip"}
          end
        else
          {status: 0, data: "Please sign in"}
        end
      end

      # Set read flag to tip
      # POST: /api/v1/accounts/set_read
      #   Parameters accepted
      #     token         String *
      #     tip_id        String *
      #     is_read       Boolean *
      #   Results
      #     {status: 1, data: set read flag}
      post :set_read do
        user = User.find_by_token params[:token]
        if user.present?
          if Tip.where(id: params[:tip_id]).count > 0
            State.find_or_create_by(user_id:user.id, tip_id: params[:tip_id]).update(read: params[:is_read])
            {status: 1, data: "Set read flag"}
          else
            {status: 0, data: "Can't find this tip"}
          end
        else
          {status: 0, data: "Please sign in"}
        end
      end

      # Set purchase pack
      # POST: /api/v1/accounts/set_purchase
      #   Parameters accepted
      #     token         String *
      #     pack_id        String *
      #   Results
      #     {status: 1, data: set purchased pack}
      post :set_purchase do
        user = User.find_by_token params[:token]
        if user.present?
          UserPack.create(user:user, pack_id: params[:pack_id])
          {status: 1, data: "Set purchased pack"}
        else
          {status: 0, data: "Please sign in"}
        end
      end
      # Set purchase pack
      # POST: /api/v1/accounts/forgot_password
      #   Parameters accepted
      #     token         String *
      #     pack_id        String *
      #   Results
      #     {status: 1, data: set purchased pack}
      post :forgot_password do
        user = User.find_by_email params[:email]
        if user.present?
          p 'The user is available'
        else
          p 'The user is not available'
        end
      end

      # Get purchased pack
      # GET: /api/v1/accounts/get_purchased_packs
      #   Parameters accepted
      #     token         String *
      #     page_number   Integer
      #   Results
      #     {status: 1, data: {id,name,price,detail}}
      get :get_purchased_packs do
        user = User.find_by_token params[:token]
        if user.present?
          {status: 1, data: user.purchased_packs(params[:page_number])}
        else
          {status: 0, data: "Please sign in"}
        end
      end

      # Get unpurchased pack
      # GET: /api/v1/accounts/get_unpurchased_packs
      #   Parameters accepted
      #     token         String *
      #     page_number   Integer
      #   Results
      #     {status: 1, data: {id,name,price,detail}}
      get :get_unpurchased_packs do
        user = User.find_by_token params[:token]
        if user.present?
          {status: 1, data: user.unpurchased_packs(params[:page_number])}
        else
          {status: 0, data: "Please sign in"}
        end
      end

      # Get terms
      # GET: /api/v1/accounts/terms
      #   Parameters accepted
      #   Results
      #     {status: 1, data: {id, terms}}
      get :terms do
        term = Term.last
        if term.present?
          {status: 1, data: {id:term.id.to_s, term:term.terms}}
        else
          {status: 0, data: {id:'', term:'Terms of service should be created by admin'}}
        end
      end

    end
  end
end
