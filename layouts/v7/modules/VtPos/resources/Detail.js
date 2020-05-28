
Vtiger_Detail_Js("VtPos_Detail_Js", {}, {
    printTicket: function(){
        $("#btn_print_ticket").click(function(){
            var TicketWindow = window.open('', 'PRINT', 'height=600,width=300');

            TicketWindow.document.write('<html><head><title>' + document.title + '</title>');
            TicketWindow.document.write('</head><body style="font-size:12px">');

            TicketWindow.document.write($("#printable").html());
            TicketWindow.document.write('</body></html>');

            TicketWindow.document.close(); // necessary for IE >= 10
            TicketWindow.focus(); // necessary for IE >= 10*/

            TicketWindow.print();
            TicketWindow.close();

            return true;
        });
    },
    registerEvents: function () {
        this._super();
        this.printTicket();
    }
});

