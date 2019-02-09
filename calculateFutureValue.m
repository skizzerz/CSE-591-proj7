function value = calculateFutureValue(save,e_month,month,spent,budget)
    value = save*e_month*(month-1)/((budget)/month*spent);
    