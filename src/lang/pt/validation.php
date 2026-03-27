<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Validation Language Lines
    |--------------------------------------------------------------------------
    |
    | The following language lines contain the default error messages used by
    | the validator class. Some of these rules have multiple versions such
    | as the size rules. Feel free to tweak each of these messages here.
    |
    */

    'accepted' => 'O campo :attribute deve ser aceite.',
    'accepted_if' => 'O campo :attribute dvee ser aceite quando :other é :value.',
    'active_url' => 'O campo :attribute deve ser um URL válido.',
    'after' => 'O campo :attribute deve ser uma data posterior a :date.',
    'after_or_equal' => 'O campo :attribute deve ser uma data posterior ou igual a :date.',
    'alpha' => 'O campo :attribute deve conter apenas letras.',
    'alpha_dash' => 'O campo :attribute deve conter apenas letras, números, traços e sublinhados.',
    'alpha_num' => 'O campo :attribute deve conter apenas letras e números.',
    'array' => 'O campo :attribute deve ser uma matriz.',
    'ascii' => 'O campo :attribute deve conter apenas caracteres alfanuméricos de um byte e símbolos.',
    'before' => 'O campo :attribute deve ser uma data anterior a :date.',
    'before_or_equal' => 'O campo :attribute deve ser uma data anterior ou igual a :date.',
    'between' => [
        'array' => 'O campo :attribute deve ter entre :min e :max número de items.',
        'file' => 'O campo :attribute deve ter entre :min e :max kilobytes.',
        'numeric' => 'O campo :attribute deve ter entre :min e :max.',
        'string' => 'O campo :attribute deve ter entre :min e :max caracteres.',
    ],
    'boolean' => 'O campo :attribute deve ser verdadeiro ou falso.',
    'confirmed' => 'O campo :attribute confirmação não corresponde.',
    'current_password' => 'A palavra-passe está incorrecta.',
    'date' => 'O campo :attribute deve ser uma data válida.',
    'date_equals' => 'O campo :attribute deve ser uma data igual a :date.',
    'date_format' => 'O campo :attribute deve corresponder ao formato :format.',
    'decimal' => 'O campo :attribute deve ter :decimal casas decimais.',
    'declined' => 'O campo :attribute deve ser recusado.',
    'declined_if' => 'O campo :attribute deve ser recusado quando :other é :value.',
    'different' => 'O campo :attribute e :other devem ser diferentes.',
    'digits' => 'O campo :attribute deve ser :digits dígitos.',
    'digits_between' => 'O campo :attribute deve ser entre :min e :max dígitos.',
    'dimensions' => 'O campo :attribute tem dimensões de imagem inválidas.',
    'distinct' => 'O campo :attribute tem um valor duplicado.',
    'doesnt_end_with' => 'O campo :attribute não deve terminar com uma das seguintes palavras: :values.',
    'doesnt_start_with' => 'O campo :attribute não deve começar por uma das seguintes palavras: :values.',
    'email' => 'O campo :attribute deve ser um endereço de correio eletrónico válido.',
    'ends_with' => 'O campo :attribute deve terminar com uma das seguintes palavras: :values.',
    'enum' => 'O :attribute seleccionado é inválido.',
    'exists' => 'O :attribute deleccionado é inválido.',
    'file' => 'O campo :attribute deve ser um ficheiro.',
    'filled' => 'O campo :attribute deve ter um valor.',
    'gt' => [
        'array' => 'O campo :attribute deve ter mais de :value items.',
        'file' => 'O campo :attribute deve ser superior a :value kilobytes.',
        'numeric' => 'O campo :attribute deve ser superior a :value.',
        'string' => 'O campo :attribute deve ser superior a :value caracteres.',
    ],
    'gte' => [
        'array' => 'O campo :attribute deve ter :value items ou mais.',
        'file' => 'O campo :attribute deve ser maior ou igual a :value kilobytes.',
        'numeric' => 'O campo :attribute deve ser maior ou igual a :value.',
        'string' => 'O campo :attribute deve ser maior ou igual a :value caracteres.',
    ],
    'image' => 'O campo :attribute deve ser uma imagem.',
    'in' => 'O :attribute seleccionado é inválido.',
    'in_array' => 'O campo :attribute deve existir em :other.',
    'integer' => 'O campo :attribute deve ser um número inteiro.',
    'ip' => 'O campo :attribute deve ser um IP address válido.',
    'ipv4' => 'O campo :attribute deve ser um IPv4 address válido.',
    'ipv6' => 'O campo :attribute deve ser um IPv6 address válido.',
    'json' => 'O campo :attribute deve ser uma JSON string válida.',
    'lowercase' => 'O campo :attribute deve ser lowercase.',
    'lt' => [
        'array' => 'O campo :attribute deve ter mens de :value items.',
        'file' => 'O campo :attribute deve ser menor do que :value kilobytes.',
        'numeric' => 'O campo :attribute deve ser menos do que :value.',
        'string' => 'O campo :attribute deve ter menos do que :value caracteres.',
    ],
    'lte' => [
        'array' => 'O campo :attribute não deve ter mais de :value items.',
        'file' => 'O campo :attribute deve ser inferior ou igual a :value kilobytes.',
        'numeric' => 'O campo :attribute deve ser inferior ou igual a :value.',
        'string' => 'O campo :attribute deve ser inferior ou igual a :value caracteres.',
    ],
    'mac_address' => 'O campo :attribute deve ser um MAC address válido.',
    'max' => [
        'array' => 'O campo :attribute não deve ter mais de :max items.',
        'file' => 'O campo :attribute não deve ser superior a :max kilobytes.',
        'numeric' => 'O campo :attribute não deve ser superior a :max.',
        'string' => 'O campo :attribute não deve ser superior a :max caracteres.',
    ],
    'max_digits' => 'O campo :attribute não deve ter mais de :max dígitos.',
    'mimes' => 'O campo :attribute deve ser um ficheiro do tipo: :values.',
    'mimetypes' => 'O campo :attribute deve ser um ficheiro do tipo: :values.',
    'min' => [
        'array' => 'O campo :attribute deve ter pelo menos :min items.',
        'file' => 'O campo :attribute deve ser pelo menos :min kilobytes.',
        'numeric' => 'O campo :attribute deve ser pelo menos :min.',
        'string' => 'O campo :attribute deve ter pelo menos :min caracteres.',
    ],
    'min_digits' => 'O campo :attribute deve ter pelo menos :min dígitos.',
    'missing' => 'O campo :attribute deve estar em falta.',
    'missing_if' => 'O campo :attribute deve estar em falta quando :other é :value.',
    'missing_unless' => 'O campo :attribute deve estar em falta a menos que :other seja :value.',
    'missing_with' => 'O campo :attribute deve estar em falta quando :values estiver presente.',
    'missing_with_all' => 'O campo :attribute deeve estar em falta quando :values estiverem presentes.',
    'multiple_of' => 'O campo :attribute deve ser um múltiplo de :value.',
    'not_in' => 'O :attribute seleccionado é inválido.',
    'not_regex' => 'O formato do campo :attribute é inválido.',
    'numeric' => 'O campo :attribute deve ser um número.',
    'password' => [
        'letters' => 'O campo :attribute deve conter pelo menos uma letra.',
        'mixed' => "O campo :attribute deve conter pelo menos uma letra maiúscula e uma letra minúscula.",
        'numbers' => "O campo :attribute deve conter pelo menos um número",
        'symbols' => "O campo :attribute deve conter pelo menos um símbolo",
        'uncompromised' => "0 :attribute apareceu numa fuga de dados. Por favor, escolha outro :attribute.",
    ],
    'present' => 'O campo :attribute deve estar presente.',
    'prohibited' => 'O campo :attribute é proibido.',
    'prohibited_if' => 'O campo :attribute é proibido quando :other é :value.',
    'prohibited_unless' => 'O campo :attribute é proibido, exceto se :other estiver entre :values.',
    'prohibits' => "O campo :attribute proíbe :other de estar presente",
    'regex' => 'O formato do campo :attribute é inválido.',
    'required' => 'O campo :attribute é necessário.',
    'required_array_keys' => 'O campo :attribute deve conter entradas para: :values.',
    'required_if' => 'O campo :attribute é necessário quando :other é :value.',
    'required_if_accepted' => 'O campo :attribute é necessário quando :other for aceite.',
    'required_unless' => 'O campo :attribute é necessário, exceto se :other estiver em :values.',
    'required_with' => 'O campo :attribute é necessário quando :values é presente.',
    'required_with_all' => 'O campo :attribute é necessário quando :values estiverem presentes.',
    'required_without' => 'O campo :attribute é necessário quando :values não estiverem presentes.',
    'required_without_all' => 'O campo :attribute é necessário quando nenhum dos :values estiverem presentes.',
    'same' => 'O campo :attribute deve corresponder a :other.',
    'size' => [
        'array' => 'O campo :attribute deve conter :size items.',
        'file' => 'O campo :attribute deve ser :size kilobytes.',
        'numeric' => 'O campo :attribute deve ser :size.',
        'string' => 'O :attribute deve ser de :size caracteres.',
    ],
    'starts_with' => 'O :attribute deve começar com uma das seguintes palavras: :values.',
    'string' => 'O :attribute deve ser uma cadeia de caracteres.',
    'timezone' => 'O :attribute deve ser um fuso horário válido.',
    'unique' => 'O :attribute já foi usado.',
    'uploaded' => 'O :attribute não foi possível carregar.',
    'uppercase' => 'O :attribute o campo deve ser maiúsculo.',
    'url' => 'O campo :attribute deve ser um ULID válido.',
    'ulid' => 'O campo :attribute deve ser um ULID válido.',
    'uuid' => 'O campo :attribute deve ser um UUID válido.',

    /*
    |--------------------------------------------------------------------------
    | Custom Validation Language Lines
    |--------------------------------------------------------------------------
    |
    | Here you may specify custom validation messages for attributes using the
    | convention "attribute.rule" to name the lines. This makes it quick to
    | specify a specific custom language line for a given attribute rule.
    |
    */

    'custom' => [
        'attribute-name' => [
            'rule-name' => 'custom-message',
        ],
    ],

    /*
    |--------------------------------------------------------------------------
    | Custom Validation Attributes
    |--------------------------------------------------------------------------
    |
    | The following language lines are used to swap our attribute placeholder
    | with something more reader friendly such as "E-Mail Address" instead
    | of "email". This simply helps us make our message more expressive.
    |
    */

    'attributes' => [],

];
