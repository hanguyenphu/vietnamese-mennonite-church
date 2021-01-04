class ReceiptPdf < Prawn::Document
    def initialize(receipt)
        super()
        @receipt = receipt 
        self.font_families.update("OpenSans" => {:normal => "public/assets/fonts/OpenSans-Regular.ttf",
                                                      :italic => "public/assets/fonts/OpenSans-Italic.ttf",
                                                      :bold => "public/assets/fonts/OpenSans-SemiBold.ttf",
                                                      :bold_italic => "public/assets/fonts/OpenSans-SemiBoldItalic.ttf"})
        font "OpenSans"
        move_down 10
        header
        move_down 15
        say_thank_table
        move_down 15
        image "public/images/logo.jpg", :scale => 0.6, :at => [30,720]
        header    
        image "public/images/logo.jpg", :scale => 0.6, :at => [30,530]
        move_down 15
        receipt_detail
        signature
        footer
        move_down 20
       
        header    
        image "public/images/logo.jpg", :scale => 0.6, :at => [30,260]
        move_down 15
        receipt_detail
        text_box "Authorized Signature: ", size: 9, :at => [250, 80]
        image "public/images/signature.jpg", :at => [370, 110], :scale => 0.07
        text_box "Hoa Le, Treasurer ", size: 9, :at => [370, 45]
        footer
       
    end

    def header
            text "Vietnamese Mennonite Church Inc.", size:12, style: :bold, align: :center
            
            text "333 Alexander Ave, Winnipeg, Manitoba Canada R3A 0N1 – Tel: (204) 947-3409", size:9, align: :center
            
            text "Charity Registration Number: 11928-5864", size:9, align: :center
    end



    def say_thank_table
        table say_thank_row_1 do
            row(0..5).size = 9
            row(0..5).column(0..1).borders = []
            row(0..5).column(0).borders = [:right]
            row(0..5).column(0..1).border_line = [:dotted]
            row(5).column(0).borders =[:bottom]
            row(5).column(1).borders =[:left, :bottom]
            columns(0..1).align = :left
        end
    end

    def say_thank_row_1
        [["Hội thánh chân thành cảm ơn quý vị đã dâng hiến rời
        rộng trong công việc nhà Chúa.","On behalf of Vietnamese Mennonite Church, I would
        like to sincerely thank you for your generous donation."]] + 
        [["Nguyện xin Chúa ban phước dư dật trên quý vị và gia
        quyến!", "May God bless you and your family!"]] + [["Thay Mặt Hội Thánh ", ""]] +
        [["Hoa Lê", "Hoa Le"]] +
        [["Thủ Quỹ", "Church Treasurer"]] + [["",""]]
     
    end

    def receipt_detail
        table receipt_table do
            row(0..1).column(0).padding_left = 30
            row(0..5).size = 9
            row(0..5).column(0..2).borders = []
            column(0).width = 250
            columns(0..2).align = :left
        end
    end

    def receipt_table
        [[@receipt.member.name, "Receipt #: ", @receipt.number]]+
        [[@receipt.description,"Donation Year: ", @receipt.donation_year]]+
        [["","Date Issued: ", Time.now.to_date]]+
        [["","Location Issued: ", "Winipeg"]]+
        [["","Donation: ", "$#{@receipt.amount}"]]
       
    end

    def signature
        text_box "Authorized Signature: ", size: 9, :at => [250, 350]
        image "public/images/signature.jpg", :at => [370, 380], :scale => 0.07
        text_box "Hoa Le, Treasurer ", size: 9, :at => [370, 315]
    end
   
    def footer
        move_down 80
        text "Official Donation Receipt for Income Tax Purposes", size:9,  align: :center
        move_down 2
        text "Canada Revenue Agency – Canada.ca/charities-giving", size:7,  align: :center
        move_down 5
        stroke_horizontal_rule
    end
end
