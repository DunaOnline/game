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
        can [:read, :osidlit_pole], Planet
        can [:read], House
        can [:read, :update, :prejmenuj_pole, :postavit_budovu], Field, :user_id => user.id
        can [:read, :update], Resource
        can [:read, :create], Vote
        can [:update], Vote, :elector => user.id
        can [:zobraz_eod], Eod, :user_id => user.id
      
        if user.emperor?
        elsif user.regent?
        elsif user.leader?
          can [:kolonizuj, :sprava_rod, :pridel_pravo, :odeber_pravo], House, :id => user.house_id
        elsif user.army_mentat?
          can [:sprava_rod], House, :id => user.house_id
        elsif user.mentat?
          can [:kolonizuj, :sprava_rod], House, :id => user.house_id
        elsif user.diplomat?
        elsif user.general?
        elsif user.vicegeneral?
        else
      
        end
      end
    else
      
    end
  end
end
