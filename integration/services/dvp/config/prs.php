<?php

return [
    /*
    |--------------------------------------------------------------------------
    | Mock PRS
    |--------------------------------------------------------------------------
    |
    | When the PRS is mocked by other services like VAD and DVA, this flag should be set to true,
    | mocking the "Refresh RID" function, always returning one and the same RID.
    |
    */
    'mock_enabled' => env('PRS_MOCK_ENABLED', false),
];
