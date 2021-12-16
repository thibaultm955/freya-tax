class CloudinaryPhotosController < ApplicationController

    def delete_photo
        @company = Company.find(params[:company_id])
        cloudinary_photo = CloudinaryPhoto.find(params[:photo_id])
        @invoice = cloudinary_photo.invoice
        cloudinary_photo.destroy
        redirect_to company_invoice_path(@company, @invoice.id)
    end
end