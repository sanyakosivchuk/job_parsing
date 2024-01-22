class JobsController < ApplicationController
  def index
    url = 'https://openai.com/careers/search'
    html = RestClient.get(url)
    doc = Nokogiri::HTML(html)

    doc.css('li.pt-16').each do |job_li|
      title = job_li.css('h3.f-subhead-2').text.strip
      location = job_li.css('span.f-body-1').text.strip
      url = job_li.css('a.ui-link').attr('href').value
      description_url = "https://openai.com#{url}"

      existing_job = Job.find_by(url: description_url)
      next if existing_job

      description_html = RestClient.get(description_url)
      description_doc = Nokogiri::HTML(description_html)
      description = description_doc.css('.section').text.strip

      about_team = ""
      about_role = ""

      ui_description = description_doc.at('.ui-description')
      about_team = ui_description.inner_html if ui_description
      about_role = description_doc.at('p:has(strong:contains("About the role")) + p')&.inner_html || ""

      Job.create(
        title: title,
        description: description,
        url: description_url,
        location: location,
        about_team: about_team,
        about_role: about_role
      )
    end
    @jobs = Job.all
  end

  def show
    @job = Job.find(params[:id])
  end
end
