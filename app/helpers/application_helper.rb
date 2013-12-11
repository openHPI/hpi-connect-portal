module ApplicationHelper
    def resource_name
        :user
    end

    def resource
        @resource ||= User.new
    end

    def devise_mapping
        @devise_mapping ||= Devise.mappings[:user]
    end

    def find_jobs_in_job_list(jobOfferArray)
		return jobOfferArray.find_jobs({
			      search:  params[:search],
			      sort: params[:sort],
			      filter: {
			                :chair => params[:chair], 
			                :start_date => params[:start_date],
			                :end_date => params[:end_date],
			                :time_effort => params[:time_effort],
			                :compensation => params[:compensation]}
			 
			    })
	end

end
