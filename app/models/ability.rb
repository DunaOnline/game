class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities

    user ||= User.new # guest user (not logged in)

    if user
      if user.admin?
        can :manage, :all
      else
        cannot [:update, :delete], Global
        can [:read, :update], User
        #can [:update], User, :id => user.id
        can [:read, :osidlit_pole, :zobraz_arrakis], Planet
        can [:read], House
        can [:read, :update, :prejmenuj_pole, :postavit_budovu], Field, :user_id => user.id
        can [:read, :update], Resource
        can [:read, :create], Vote
        can [:update], Vote, :elector => user.id
        can [:zobraz_eod], Eod, :user_id => user.id
      
        if user.emperor?
        end
        if user.regent?
        end
        if user.leader?
          can [:kolonizuj, :sprava_rod], House do |house|
            user.try(:house) == house
          end 
          #:id => user.house_id
          can [:pridel_pravo, :odeber_pravo], User do |hrac|
            hrac.house == user.house
          end
        end
        if user.army_mentat?
          can [:sprava_rod], House, :id => user.house_id
        end
        if user.mentat?
          can [:kolonizuj, :sprava_rod], House, :id => user.house_id
        end
        if user.diplomat?
        end
        if user.general?
        end
        if user.vicegeneral?
        end
      end
    else
      
    end
  end
end
