/**
 * @method
 * @name registerAdapter
 * @memberof WORKAREA.analytics
 */
WORKAREA.analytics.registerAdapter('saved_lists', function () {
    'use strict';

    return {
        'addToSavedList': function (payload) {
            if (payload.id) {
                $.ajax({
                    type: 'POST',
                    url: WORKAREA.routes.storefront.analyticsSavedListAddPath(
                        { product_id: payload.id }
                    ),
                });
            }
        },
        'removeFromSavedList': function (payload) {
            if (payload.id) {
                $.ajax({
                    type: 'POST',
                    url: WORKAREA.routes.storefront.analyticsSavedListRemovePath(
                        { product_id: payload.id }
                    ),
                });
            }
        }
    };
});
