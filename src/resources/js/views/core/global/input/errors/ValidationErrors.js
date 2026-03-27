export default (errorObject, field, isArray = true) => {
    if (!Object.keys(errorObject).length)
        return '';
    if (isArray){
        let error = errorObject[field]
        if (error){
            return error[0];
        }
        return '';
    }
    return  errorObject[field];
};
