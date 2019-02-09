function value = calculateValue(weight, cvss, category, impacted)
    value = weight*cvss*category*impacted;