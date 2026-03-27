import store from "@store";
import {computed} from "vue"
import moment from "moment";

const settingInfo = computed(() => store.getters["setting/setting"])

export const optional = (obj, ...props) => {
    if (!obj || typeof obj !== 'object')
        return undefined;
    const val = obj[props[0]];
    if (props.length === 1 || !val) return val;
    const rest = props.slice(1);
    return optional.apply(null, [val, ...rest])
};

export const textTruncate = (str, length, ending) => {
    if (length == null) {
        length = 50;
    }
    if (ending == null) {
        ending = '...';
    }
    str = str.replace(/(<([^>]+)>)/ig, '');
    str = str.replace(/&nbsp;/g, ' ');
    if (str.length > length) {
        return str.substring(0, length - ending.length) + ending;
    } else {
        return str;
    }
}

export const formDataAssigner = function (formData = new FormData, dataObject) {
    Object.keys(dataObject).map((key) => {
        if (dataObject[key] && !dataObject[key].length > 0 && Object.keys(dataObject[key]).length > 0) {
            Object.keys(dataObject[key]).map(childKey => {
                return formData.append(key + `[${childKey}]`, dataObject[key][childKey]);
            })
        } else if (Array.isArray(dataObject[key])) {
            dataObject[key].map((el, index) => {
                Object.keys(el).map(objectKeys => {
                    formData.append(key + `[${index}][${objectKeys}]`, el[objectKeys]);
                });
            })
        } else {
            return formData.append(key, dataObject[key]);
        }
    });
    return formData;
}

export const date_format = () => {
    return {
        'd-m-Y': 'DD-MM-YYYY',
        'm-d-Y': 'MM-DD-YYYY',
        'Y-m-d': 'YYYY-MM-DD',
        'm/d/Y': 'MM/DD/YYYY',
        'd/m/Y': 'DD/MM/YYYY',
        'Y/m/d': 'YYYY/MM/DD',
        'm.d.Y': 'MM.DD.YYYY',
        'd.m.Y': 'DD.MM.YYYY',
        'Y.m.d': 'YYYY.MM.DD',
    };
};

export const formatted_date = () => {
    return date_format()[optional(settingInfo.value, 'date_format')];
};

export const formatted_time = () => {
    return optional(settingInfo.value, 'time_format') === 'h' ? '12' : '24';
}

export const time_format = () => {
    const settingsData = settingInfo.value
    const format = optional(settingsData, 'time_format');
    return format === 'h' ? `${settingsData.time_format}:mm A` : `${settingsData.time_format}:mm`;
}

export const formatDateToLocal = (date, withTime = false, time = null) => {
    if (!date)
        return '';
    if (!time) {
        withTime = false;
    }
    const formatString = withTime ? `${formatted_date()} ${time_format()}` : formatted_date();

    if (time) {
        return moment(`${date} ${time}`).utc(false)
            .local()
            .format(formatString);
    }
    return moment(date).utc(false)
        .local()
        .format(formatString);
};

export const formatDateTimeToLocal = (date) => {
    const formatString = `${formatted_date()} ${time_format()}`;
    return moment(date).utc(false)
        .local()
        .format(formatString);
};

export const getThousandSeparator = () => {
    return settingInfo.value.thousand_separator === 'space' ? ' ' : settingInfo.value.thousand_separator;
}

export const getCurrencySymbol = () => {
    return settingInfo.value.currency_symbol ? settingInfo.value.currency_symbol : ' '
}
export const getCurrencyPosition = () => {
    return settingInfo.value.currency_position ? settingInfo.value.currency_position : ' '
}
export const getDecimalSeparator = () => {
    return settingInfo.value.decimal_separator ? settingInfo.value.decimal_separator : ' '
}
export const getNumberOfDecimal = () => {
    return settingInfo.value.number_of_decimal ? settingInfo.value.number_of_decimal : ' '
}

export const numberFormatter = number => {
    if (!isNaN(parseFloat(number))) {
        number = parseFloat(number).toFixed(getNumberOfDecimal());
        let parts = number.toString().split(".");
        parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, getThousandSeparator());
        return parts.join(getDecimalSeparator());
    }
    return 0;
}
export const numberWithCurrencySymbol = number => {
    let modifiedValue;
    let formattedNumber = numberFormatter(number).toString();
    let currencySymbol = getCurrencySymbol().toString();

    if (getCurrencyPosition() === 'prefix_with_space') {
        modifiedValue = currencySymbol + ' ' + formattedNumber;
    } else if (getCurrencyPosition() === 'prefix_only') {
        modifiedValue = currencySymbol + formattedNumber;
    } else if (getCurrencyPosition() === 'suffix_with_space') {
        modifiedValue = formattedNumber + ' ' + currencySymbol;
    } else {
        modifiedValue = formattedNumber + currencySymbol;
    }
    return modifiedValue;
}
