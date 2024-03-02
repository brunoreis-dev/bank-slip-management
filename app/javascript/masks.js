$(document).ready(function () {
  $(".amount-field").mask("000.000.000.000.000,00", { reverse: true });
  $(".due-date-field").mask("00/00/0000");
  $(".cep-field").mask("00000-000");
  $(".cpf-cnpj-field").on("input", function (event) {
    var target = $(event.currentTarget);
    var currentValue = target.val().replace(/[^\d]/g, ""); // Remove caracteres não numéricos

    if (currentValue.length >= 11) {
      target.mask("00.000.000/0000-00", { reverse: true });
    } else {
      target.mask("000.000.000-00", { reverse: true });
    }
  });
});
