
// @author Brahim EL AASSAL , belaassal@gmail.com

Vtiger_Edit_Js("VtPos_Pos_Js", {}, {
    productExist: false,
    salesTax: 0,
    separator: ",",
    TicketTime: "",
    payMode: "LBL_CACHE", //"LBL_CACHE", "LBL_CREDIT", "LBL_CHECK","LBL_CB"
    inUse: false,
    isEditable: true,
    getBarCode: function () {
        var instance = this;
        $("#code_scanner_input").on("keydown", function (event) {
            var code = $("#code_scanner_input").val();
            if (event.which === 13 || event.which === 9) { //13=Enter ,9=Tab
                event.preventDefault();
                event.stopImmediatePropagation();
                $("#code_scanner_input").val("");
                var params = {
                    "module": "VtPos",
                    "action": "BarsearchAjax",
                    "code": code
                };
                instance.isProductExist(code);
                if (!instance.productExist) {
                    AppConnector.request(params).then(function (data) {
                        if (data.success && data.result.length !== 0) {
                            data = data.result;
                            var qnty = 1;
                            var productid = data.productid;
                            var uprice = data.unit_price;
                            var pname = data.productname;
                            instance.addProduct(pname, productid, code, qnty, uprice);
                        } else {
                            var params = {
                                type: "error",
                                title: app.vtranslate('JS_NON_FOUND_PRODUCT')
                            }
                            Vtiger_Helper_Js.showPnotify(params);
                        }
                    });
                }
            }
        });


    },
    addProduct: function (pname, productid, code, qnty, uprice) {
        var instance = this;
        var found = false;
        $("input[name='selectedproduct']").each(function () {
            var prodid = $(this).data("prodid");
            if (prodid === productid) {
                found = true;
                $(this).prop("checked", true);
            }
        });
        if (found) {
            $("#btn_increase_qnty").click();
        } else {
            var tprice = (qnty * uprice);
            var x = $("input[name='selectedproduct']").length;
            x++;
            var radio = '<input type="radio" name="selectedproduct"  data-prodid="' + productid + '" data-code="' + code + '" data-name="' + pname + '" data-qnty="' + qnty + '" data-uprice="' + uprice + '" data-tprice="' + tprice + '">';
            var product_line = "<tr class=''><td>" + x + "</td><td>" + radio + "</td><td>" + pname + "</td><td>" + qnty + "</td><td>" + uprice + "</td><td>" + tprice + "</td></tr>";

            $("#products_table").append(product_line);

            $("input[name='selectedproduct']").last().prop("checked", true);
            if (!this.inUse) {
                this.inUse = true;
            }
        }
        instance.calcTotalPrice();
        instance.selectTableRow();
        instance.highLightRow();
    },
    selectTableRow: function () {
        var instance = this;
        $("#products_table tr").click(function () {
            var element = $(this).find("input");
            element.prop("checked", true);
            instance.highLightRow();
        });
    },
    highLightRow: function () {
        $("#products_table tr").removeClass("bg-warning");
        $("input[name='selectedproduct']:checked").parents("tr").addClass("bg-warning");
        ;
    },
    incressQnty: function () {
        var instance = this;
        $("#btn_increase_qnty").click(function (event) {
            var element = $("#products_table").find("input[name='selectedproduct']:checked");
            if (element.length !== 0) {
                var value = element.data("qnty");
                instance.updateElementData(element, ++value);
                event.stopImmediatePropagation();
                instance.calcTotalPrice();
                instance.setFocusToBarCodeinput();
            } else {
                var params = {
                    type: "error",
                    title: app.vtranslate('JS_PLEASE_SELECT_PRODUCT')
                }
                Vtiger_Helper_Js.showPnotify(params);
            }
        });
    },
    decressQnty: function () {
        var instance = this;
        $("#btn_decrease_qnty").click(function (event) {
            var element = $("#products_table").find("input[name='selectedproduct']:checked");
            if (element.length !== 0) {
                var value = element.data("qnty");
                if (value > 1) {
                    instance.updateElementData(element, --value);
                    event.stopImmediatePropagation();
                    instance.calcTotalPrice();
                    instance.setFocusToBarCodeinput();
                }
            } else {
                var params = {
                    type: "error",
                    title: app.vtranslate('JS_PLEASE_SELECT_PRODUCT')
                }
                Vtiger_Helper_Js.showPnotify(params);
            }
        });
    },
    editQnty: function () {
        var instance = this;
        $("#btn_edit_qnty").click(function () {
            var element = $("#products_table").find("input[name='selectedproduct']:checked");
            if (element.length !== 0) {
                var qnty = element.data("qnty");
                qnty = Number(qnty);
                $("#quantity_input").val(qnty);
                $('#QntyPad').modal('show');
                $("#quantity_input").focus();
            } else {
                var params = {
                    type: "error",
                    title: app.vtranslate('JS_PLEASE_SELECT_PRODUCT')
                }
                Vtiger_Helper_Js.showPnotify(params);
            }
        });

        $("#QntyPad .btnok").click(function (event) {

            var qnty = $("#quantity_input").val();
            var element = $("#products_table").find("input[name='selectedproduct']:checked");
            if (qnty !== "" && qnty > 0) {
                $('#QntyPad').modal('hide');
                instance.updateElementData(element, qnty);
                event.stopImmediatePropagation();
                instance.calcTotalPrice();
                instance.setFocusToBarCodeinput();
            }
        });
    },
    deleteProduct: function () {
        var instance = this;
        $("#btn_delete_product").click(function (event) {
            var element = $("#products_table").find("input[name='selectedproduct']:checked");
            if (element.length !== 0) {
                var message = app.vtranslate('JS_DELETE_PRODUCT_CONFIRMATION');
                app.helper.showConfirmationBox({'message': message}).then(
                        function (e) {
                            element.parents("tr").remove();
                            instance.calcTotalPrice();
                            instance.setFocusToBarCodeinput();
                        },
                        function (error, err) {

                        }
                );


            } else {
                var params = {
                    type: "error",
                    title: app.vtranslate('JS_PLEASE_SELECT_PRODUCT')
                }
                Vtiger_Helper_Js.showPnotify(params);
            }
        });
    },
    updateElementData: function (element, qnty) {
        element.data("qnty", qnty);
        var uprice = element.data("uprice");
        var tprice = qnty * uprice;
        tprice = (Math.round(tprice * 100) / 100);
        element.data("tprice", tprice);
        element.parents("tr").find("td:nth-child(4)").html(qnty);
        element.parents("tr").find("td:nth-child(6)").html(tprice);
    },
    isProductExist: function (barcode) {
        var instance = this;
        instance.productExist = false;
        $("input[name='selectedproduct']").each(function () {
            var code = $(this).data("code");
            if (code == barcode) { // == unsted using ===
                $(this).prop("checked", true);
                instance.highLightRow();
                $("#btn_increase_qnty").click();
                instance.productExist = true;
                return false;
            }
        });
    },
    calcTotalPrice: function () {
        var sum = Number(0);
        var net = Number(0);
        var instance = this;
        var element = $("input[name='selectedproduct']");
        var items = 0;
        if (element.length !== 0) {
            element.each(function () {
                var qnty = $(this).data("qnty");
                items += Number(qnty);
                var uprice = $(this).data("uprice");
                var tprice = Math.round((qnty * uprice) * 100) / 100;
                sum += tprice;
                instance.updateElementData($(this), qnty);
                sum = Math.round(sum * 100) / 100;
                $("#items").html(items);
                $("#sub_total").data("sub_total", sum).html(sum);
                var discount = $("#discount").data("discount");
                net = sum - discount;
                var TotalTax = (net * instance.salesTax) / 100;
                TotalTax = (Math.round(TotalTax * 100)) / 100; // 2 decimal digits
                $("#total_tax").data("total_tax", TotalTax).html(TotalTax);

                var total_pay = (net + TotalTax);
                total_pay = (Math.round(total_pay * 100)) / 100; // 2 decimal digits
                $("#total_price").data("total_price", total_pay).html(total_pay);

                var amount = $("#tendered").data("amount");
                if (amount > 0) {
                    var change = (Math.round((amount - total_pay) * 100) / 100);
                    $("#change").data("change", change).html(change);
                } else {
                    $("#tendered").data("amount", 0).html("0");
                    $("#change").data("change", 0).html("0");
                }
            });
            $("#btn_crdt").prop("disabled", false);
            $("#btn_cc").prop("disabled", false);
            $("#btn_done").prop("disabled", false);
            $("#btn_cancel").prop("disabled", false);
            $("#btnTicketPrint").prop("disabled", false);
        } else {
            $("#items").html("0");
            $("#sub_total").data("sub_total", 0).html("0");
            $("#total_tax").data("total_tax", 0).html("0");
            $("#total_price").data("total_price", 0).html("0");
            $("#discount").data("discount", 0).html("0");
            $("#tendered").data("amount", 0).html("0");
            $("#change").data("change", 0).html("0");
            $("#btn_crdt").prop("disabled", true);
            $("#btn_cc").prop("disabled", true);
            $("#btn_done").prop("disabled", true);
            $("#btn_cancel").prop("disabled", true);
            $("#btnTicketPrint").prop("disabled", true);
        }
        instance.ajaxGetCurrentDateTime();
    },
    focusBarCode: function () {
        $("#optionsTab a:first").on('shown', function (e) {
            $("#code_scanner_input").focus();
        });
        $("#code_scanner_input").focus(function () {
            $("#code_scanner_input").css("background-color", "#dff0d8");
        });
        $("#code_scanner_input").focusout(function () {
            $("#code_scanner_input").css("background-color", "");
        });

    },
    onLoadPage: function () {
        $("#code_scanner_input").focus();
        var screen_hight = $(document).height();
        $("#timer_display").hide();
        screen_hight = Math.round((screen_hight * 86) / 100);
        var semi_hi = Math.round((screen_hight * 60) / 100);
        $("#Fav_Products").height(semi_hi);
        $("#detail_product").parent("div").height(semi_hi);
        $("#clients_list").select2();
    },
    setFocusToBarCodeinput: function () {
        $("#code_scanner_input").focus();
    },
    getSalesTax: function () {
        this.salesTax = $("#SALES_TAX").val();
    },
    padBtns: function () {
        var instance = this;
        $('.btn0').click(function () {
            var value = $(this).parent(".modal-body").find("input").val();
            $(this).parent(".modal-body").find("input").val(value + "" + 0);
        });
        $('.btn1').click(function () {
            var value = $(this).parent(".modal-body").find("input").val();
            $(this).parent(".modal-body").find("input").val(value + "" + 1);
        });
        $('.btn2').click(function () {
            var value = $(this).parent(".modal-body").find("input").val();
            $(this).parent(".modal-body").find("input").val(value + "" + 2);
        });
        $('.btn3').click(function () {
            var value = $(this).parent(".modal-body").find("input").val();
            $(this).parent(".modal-body").find("input").val(value + "" + 3);
        });
        $('.btn4').click(function () {
            var value = $(this).parent(".modal-body").find("input").val();
            $(this).parent(".modal-body").find("input").val(value + "" + 4);
        });
        $('.btn5').click(function () {
            var value = $(this).parent(".modal-body").find("input").val();
            $(this).parent(".modal-body").find("input").val(value + "" + 5);
        });
        $('.btn6').click(function () {
            var value = $(this).parent(".modal-body").find("input").val();
            $(this).parent(".modal-body").find("input").val(value + "" + 6);
        });
        $('.btn7').click(function () {
            var value = $(this).parent(".modal-body").find("input").val();
            $(this).parent(".modal-body").find("input").val(value + "" + 7);
        });
        $('.btn8').click(function () {
            var value = $(this).parent(".modal-body").find("input").val();
            $(this).parent(".modal-body").find("input").val(value + "" + 8);
        });
        $('.btn9').click(function () {
            var value = $(this).parent(".modal-body").find("input").val();
            $(this).parent(".modal-body").find("input").val(value + "" + 9);
        });
        $('.btnsep').click(function () {
            var value = $(this).parent(".modal-body").find("input").val();
            value = Number(value);
            if ($.isNumeric(value + "" + instance.separator)) {
                $(this).parent(".modal-body").find("input").val(value + "" + instance.separator);
            }
        });
        $('.btnclear').click(function () {
            $(this).parents(".modal-body").find("input").val("");
        });
        $('.btnback').click(function () {
            var value = $(this).parents(".modal-body").find("input").val();
            var end = value.substring(0, value.length - 1);
            $(this).parents(".modal-body").find("input").val(end);
        });
    },
    getSeparator: function () {
        this.separator = $("#SEPARATOR").val();
    },
    imgProductsEvent: function () {
        $(".imgProducts").click(function () {
            var code = $(this).data("code");
            $("#code_scanner_input").focus();
            $("#code_scanner_input").val(code);
            var e = jQuery.Event("keydown");
            e.which = 13; // Enter
            $("#code_scanner_input").trigger(e);

        });
        $("#btn_bar_search").click(function () {
            var barcode = $("#code_scanner_input").val();
            if (barcode != "") {
                var e = jQuery.Event("keydown");
                e.which = 13; // Enter
                $("#code_scanner_input").trigger(e);
            }
        });
    },
    updateTimeLabel: function () {
        setInterval(function () {
            var min = (new Date()).getUTCMinutes();
            min = min < 10 ? "0" + min : min;
            var time = (new Date()).getHours() + ":" + min;
            $("#timer_display").html(time).show('slow');
        }, 30000);
    },
    discountPadShow: function () {
        var instance = this;
        $("#btn_discount").click(function () {
            var value = $("#discount").data("discount");
            $("#discount_input").val(value);
            $('#DiscountPad').modal('show');
            $("#discount_input").focus();
        });
        $("#DiscountPad .btnok").click(function () {
            var value = $("#discount_input").val();
            value = parseFloat(value);
            $("#discount").html(value);
            $("#discount").data("discount", value);
            instance.calcTotalPrice();
            $('#DiscountPad').modal('hide');
            instance.ajaxGetCurrentDateTime();
        });
    },
    selectClient: function () {
        $("#btn_crdt").click(function () {
            $("#customer_credit").modal("show");
        });
        $("#clients_list").on("change", function () {
            var value = $(this).val();
            var element = $(this).find(":selected");
            var credit = element.data("credit");
            var salutation = element.data("salutation");
            var name = element.text();
            if (value !== "") {
                $("#client_info").parents("div").show();
                $("#client_info").html(salutation + " " + name);
                $("#client_credit").html(credit);
            } else {
                $("#client_info").parent("div").hide();
            }
        });
    },
    saveSale: function () {
        var instance = this;
        var client = $("#clients_list :selected").val();
        var ht_price = $("#sub_total").data("sub_total");
        var ttc_price = $("#total_price").data("total_price");
        var tax = $("#total_tax").data("total_tax");
        var paiment_method = this.payMode;
        var discount = $("#discount").data("discount");
        var paid_cash = $("#tendered").data("amount");
        var change = $("#change").data("change");
        var products = [];
        var element = $("input[name='selectedproduct']");
        element.each(function () {

            var prodid = $(this).data("prodid");
            var code = $(this).data("code");
            var name = $(this).data("name");
            var qnty = $(this).data("qnty");
            var uprice = $(this).data("uprice");
            var tprice = $(this).data("tprice");

            var product = {
                "productid": prodid,
                "quantity": qnty,
                "unit_price": uprice,
                "total_price": tprice,
            };
            products.push(product);
        });
        var params = {
            "module": "VtPos",
            "action": "SaveAjax",
            "client": client,
            "prix_ht": ht_price,
            "prix_ttc": ttc_price,
            "tax": tax,
            "pay_method": paiment_method,
            "money_get": paid_cash,
            "money_back": change,
            "remise_price": discount,
            "products": JSON.stringify(products)

        };

        AppConnector.request(params).then(function (data) {
            instance.resetAll();
        });


    },
    editChangeBtn: function () {

        $("#btn_tendered").click(function () {
            $("#changePad").modal("show");
            $("#change_input").focus();
        });
    },
    setChange: function () {
        var instance = this;
        $("#changePad .btnok").click(function () {
            var amount = $("#change_input").val();
            var total = $("#total_price").data("total_price");
            var change = (Math.round((amount - total) * 100) / 100);
            $("#tendered").data("amount", amount).html(amount);
            $("#change").data("change", change).html(change);
            $("#changePad").modal("hide");
            instance.calcTotalPrice();
            instance.ajaxGetCurrentDateTime();
        });
    },
    searchProduct: function () {
        var instance = this;
        $("#item_browser").select2();
        $("#item_browser").on("change", function () {
            var product = $(this).find(":selected");
            if (product.val() !== "") {
                var id = product.data("id");
                var name = product.text();
                var image = product.data("image");
                if (image === "") {
                    image = $("#empty_img").val();
                }
                var price = product.data("price");
                var category = product.data("category");
                var stock = product.data("stock");
                $("#detail_product").show();
                $("#detail_product").find("img").prop("src", image);
                $("#detail_product").find(".name").html(name);
                $("#detail_product").find(".price").html(price);
                $("#detail_product").find(".stock").html(stock);
                $("#detail_product").find(".categ").html(category);
            }
        });
        $("#add_item").click(function () {
            var product = $("#item_browser").find(":selected");
            var code = product.val();
            if (code !== "") {
                var id = product.data("id");
                var name = product.text();
                var price = product.data("price");

                instance.addProduct(name, id, code, 1, price);
            }

            $("#detail_product").hide();
            $("#item_browser").select2().select2("val", "");

        });
    },
    printTicket: function () {
        $("#btnTicketPrint").click(function () {
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
    setupPrintableDiv: function () {
        var products = $("input[name='selectedproduct']");
        var count = products.length;
        var header = $("#header").html();
        var date = this.TicketTime;
        date = '<div style="text-align: center;display: block">' + date + '</div>';
        header = "<b>" + header + "" + date + "</b><hr>";
        var footer = $("#footer").html();
        footer = "<hr><b>" + footer + "</b>";
        var vTable = "<table  style='font-size:12px'><tbody><tr><td>Qnty</td><td>Unit Price</td><td>Total Price</td></tr></tbody></table>";
        $("#printable").html("");
        $("#printable").prepend(header);
        $("#printable").append(vTable);

        if (count > 0) {
            products.each(function () {
                var name = $(this).data("name");
                var qnty = $(this).data("qnty");
                var uprice = $(this).data("uprice");
                var tprice = $(this).data("tprice");
                var line = '<tr><td colspan="3"><u><b>' + name + '</b></u></td></tr><tr><td>' + qnty + '</td><td>' + uprice + '</td><td>' + tprice + '</td></tr>';
                $("#printable table tbody").append(line);
            });
        }

        var subTotal = $("#sub_total").data("sub_total");
        var Total = $("#total_price").data("total_price");
        var Tax = $("#total_tax").data("total_tax");
        var Discount = $("#discount").data("discount");
        var Paid = $("#tendered").data("amount");
        var Change = $("#change").data("change");

        Paid = (typeof Paid === "undefined") ? 0 : Paid;
        Change = (typeof Change === "undefined") ? 0 : Change;
        Discount = (typeof Discount === "undefined") ? 0 : Discount;

        var priceinfo = "<hr>";
        priceinfo += "<table width='100%' style='font-size:12px'>";
        priceinfo += "<tr><td>subTotal</td><td>" + subTotal + "</td></tr>";
        priceinfo += "<tr><td>Discount</td><td>" + Discount + "</td></tr>";
        priceinfo += "<tr><td>Tax</td><td>" + Tax + "</td></tr>";
        priceinfo += "<tr><td>Total</td><td>" + Total + "</td></tr>";
        priceinfo += "<tr><td>Paid</td><td>" + Paid + "</td></tr>";
        priceinfo += "<tr><td>Change</td><td>" + Change + "</td></tr>";
        priceinfo += "</table>";
        $("#printable").append(priceinfo);
        $("#printable").append(footer);

    },
    ajaxGetCurrentDateTime: function () {
        var instance = this;
        var time = Math.round(+new Date() / 1000);
        var params = {
            "module": "VtPos",
            "action": "DateTimeAjax",
            "time": time
        };
        AppConnector.request(params).then(function (data) {
            if (data.success && data.result.length !== 0) {
                data = data.result;
                instance.TicketTime = data.current;
                instance.setupPrintableDiv();
            }
        });
    },
    resetAll: function () {
        var elements = $("input[name='selectedproduct']");
        elements.each(function () {
            $(this).parents("tr").remove();
        });
        this.calcTotalPrice();
        this.payMode = "LBL_CACHE";
        $("#clients_list").select2();
        $("#clients_list").change();
        $("#check_cb_div").show();
        $("#discount_input").val("");
        $(".forcashuse").show();
        $("#cstm_credit_name").html("");
        $("#cstm_credit_actual").html("");
        $("#cstm_credit_final").html("");
        $("#cstm_credit_info").hide();
        $("#btn_crdt").show();
        $("#btn_cc").show();
        this.inUse = false;
    },
    finishSale: function () {
        var instance = this;
        $("#btn_done").click(function () {
            var message = app.vtranslate('JS_SALE_DONE_CONFIRMATION');
            app.helper.showConfirmationBox({'message': message}).then(
                    function (e) {
                        instance.saveSale();
                    },
                    function (error, err) {

                    }
            );

        });
    },
    cancelSale: function () {
        var instance = this;
        $("#btn_cancel").click(function () {
            var message = app.vtranslate('JS_CANCEL_SALE_CONFIRMATION');
            app.helper.showConfirmationBox({'message': message}).then(
                    function (e) {
                        instance.resetAll();
                    },
                    function (error, err) {

                    }
            );
        });
    },
    payByCredit: function () {
        var instance = this;
        $("#btn_credit").click(function () {
            var message = app.vtranslate('JS_SALE_CREDIT_CLIENT_CONFIRMATION');
            var element = $("#clients_list :selected");
            var credit = element.data("credit");
            var ttc_price = $("#total_price").data("total_price");
            var final_credit = parseFloat(credit) + parseFloat(ttc_price)
            var salutation = element.data("salutation");
            var client_name = salutation + " " + element.text();
            message = message + client_name;
            app.helper.showConfirmationBox({'message': message}).then(
                    function (e) {
                        instance.payMode = "LBL_CREDIT";
                        $("#btn_crdt").hide();
                        $("#btn_cc").hide();
                        $(".forcashuse").hide();
                        $("#customer_credit").modal("hide");
                        $("#cstm_credit_info").show();
                        $("#cstm_credit_name").html(client_name);
                        $("#cstm_credit_actual").html(credit);
                        $("#cstm_credit_final").html(final_credit);
                        $("#clients_list").attr("disabled", true).select2();
                        $("#btn_cancel").prop("disabled", true);
                    },
                    function (error, err) {

                    }
            );

        });
    },
    exitPage: function () {
        var instance = this;
        window.onbeforeunload = function () {
            if (instance.inUse) {
                return app.vtranslate("JS_CHANGES_WILL_BE_LOST");
            }
        };
    },
    payByCB: function () {
        var instance = this;
        $("#btn_cc").click(function () {
            $("#credit_card").modal("show");
            $('#credit_card').on('shown.bs.modal', function () {
                $('#stripe_tracks').focus();
            });
            var alert_div = $("#stripe_tracks").parent("div");
            var alert_span = $("#stripe_tracks").siblings("span");
            $("#stripe_tracks").on("keydown", function (event) {
                if (event.which === 13) {
                    alert_span.html(app.vtranslate("JS_PLEASE_WAIT"));
                    alert_div.removeClass("alert-danger");
                    alert_div.addClass("alert-warning");
                    var tracks = $("#stripe_tracks").val();
                    if (tracks.length > 70) {
                        var ar_trks = tracks.split("?");
                        var track1 = ar_trks[0];
                        var amount = $("#total_price").data("total_price");
                        var params = {
                            "module": "VtPos",
                            "action": "Stripe",
                            "track": track1,
                            "amount": amount
                        };
                        AppConnector.request(params).then(function (data) {
                            if (data.success && data.result.length !== 0) {
                                instance.payMode = "LBL_CB";
                                data = data.result.Response;
                                console.log(data);
                                var paid = data.paid;
                                var status = data.status; //succeeded -- pending -- failed
                                if (status === "succeeded" && paid) {
                                    var message = "<div>";
                                    message += "<b>name : </b>" + data.source.name + "<br/>";
                                    message += "<b>status : </b>" + data.status + "<br/>";
                                    message += "<b>network_status : </b>" + data.outcome.network_status + "<br/>";
                                    message += "<b>reason : </b>" + data.outcome.reason + "<br/>";
                                    message += "<b>risk_level : </b>" + data.outcome.risk_level + "<br/>";
                                    message += "<b>seller_message : </b>" + data.outcome.seller_message + "<br/>";
                                    message += "<b>type : </b>" + data.outcome.type + "<br/>";
                                    message += "</div>";
                                    alert_div.removeClass("alert-warning");
                                    alert_div.addClass("alert-success");
                                    alert_span.html(message);
                                    $("#btn_cancel").prop("disabled", true);
                                    $("#btn_crdt").hide();
                                    $("#btn_cc").hide();
                                    $("#credit_card").modal("hide");
                                }else if(typeof data.error === "object"){
                                    alert_div.removeClass("alert-warning").addClass("alert-danger");
                                    var message = "<div>";
                                    message += "<h3>ERROR :</h3>";
                                    message += "<b>type : </b>" + data.error.type + "<br/>";
                                    message += "<b>message : </b>" + data.error.message + "<br/>";
                                    message += "</div>";
                                    alert_span.html(message);
                                }
                                
                                
                            }
                        });
                    } else {
                        $('#stripe_tracks').focus();
                        alert_span.html(app.vtranslate("JS_ERROR_SWIPE"));
                    }
                }
            });
        });
    },
    /**
     * Function which will register basic events which will be used in quick create as well
     */
    registerEvents: function (container) {
        this._super(container);
        this.onLoadPage();
        this.getSalesTax();
        this.selectClient();
        this.getSeparator();
        this.updateTimeLabel();
        this.discountPadShow();
        this.imgProductsEvent();
        this.editChangeBtn();
        this.setChange();

        this.exitPage();

        this.getBarCode();
        this.selectTableRow();
        this.incressQnty();
        this.decressQnty();
        this.editQnty();
        this.deleteProduct();
        this.focusBarCode();
        this.padBtns();
        this.searchProduct();
        this.printTicket();
        this.payByCredit();
        this.payByCB();
        this.finishSale();
        this.cancelSale();

    }
});

jQuery(document).ready(function () {

    if ($("#sidebar-essentials").hasClass("hide") === false) {
        $(".essentials-toggle").trigger("click");
    }

});