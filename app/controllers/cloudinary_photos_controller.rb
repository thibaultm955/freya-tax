class CloudinaryPhotosController < ApplicationController

    def delete_photo
        cloudinary_photo = CloudinaryPhoto.find(params[:photo_id])
        @invoice = cloudinary_photo.invoice
        cloudinary_photo.destroy
        redirect_to company_invoice_path(current_user.company, @invoice.id)
    end
end