class Api::V1::SeatsController < ApplicationController
    def create
        @prepare_seats = VerifySeating.seat_arrangements(array: params[:array], passenger: params[:passenger_no])
        render json: @prepare_seats, status: 201
    end
end