<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Rid extends Model
{
    public $fillable = [
        'user_id',
        'rid',
    ];
}
