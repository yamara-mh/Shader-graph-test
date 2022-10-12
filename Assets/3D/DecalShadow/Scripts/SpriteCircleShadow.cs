using UnityEngine;

public class SpriteCircleShadow : MonoBehaviour
{
    [SerializeField] public Transform RayOriginTransform;
    [SerializeField] public SpriteRenderer Renderer;
    [SerializeField] public bool FixedRendererRotation = true;
    [SerializeField] public float RayMaxDistance = 1000f;
    [SerializeField] public float RayRadius = 0f;
    [SerializeField] public float RayMargin = 0.1f;
    [SerializeField] public float RayHitMargin = 0.01f;
    [SerializeField] public Vector3 RayDirection = new Vector3(0f, -1f, 0f);
    [SerializeField] public LayerMask RayMask = int.MaxValue;
    [SerializeField] public float BaseSizeRate = 1f;
    [SerializeField] public float AddSizeRate = 0.1f;
    [SerializeField, Range(0f, 1f)] public float MinOpacity = 0.1f;
    [SerializeField, Range(0f, 1f)] public float MaxOpacity = 0.9f;
    [SerializeField] public float AddOpacityRate = 0.1f;

    [System.NonSerialized] public Vector2 DefaultScale = Vector2.one;

    private void Start()
    {
        DefaultScale = Renderer.size;
    }

    private void LateUpdate()
    {
        if (RayRadius == 0f)
        {
            if (Physics.Raycast(RayOriginTransform.position + -RayDirection * RayMargin, RayDirection, out var hit1, RayMaxDistance + RayMargin, RayMask))
            {
                Renderer.enabled = true;
                HitProcessing(hit1);
                return;
            }
            Renderer.enabled = false;
        }
        else if (Physics.SphereCast(RayOriginTransform.position + -RayDirection * RayRadius + -RayDirection * RayMargin,
            RayRadius, RayDirection, out var hit2, RayMaxDistance + RayRadius + RayMargin, RayMask))
        {
            Renderer.enabled = true;
            HitProcessing(hit2);
            return;
        }
        Renderer.enabled = false;
    }

    private void HitProcessing(RaycastHit hit)
    {
        if (FixedRendererRotation) Renderer.transform.forward = -RayDirection;
        else Renderer.transform.forward = hit.normal;

        var distance = hit.distance;
        var pos = RayOriginTransform.position + RayDirection * (distance - RayMargin - RayHitMargin);
        Renderer.transform.position = pos;

        var color = Renderer.color;
        color.a = Mathf.Clamp(1f - Mathf.Max(0f, distance - RayMargin) * AddOpacityRate, MinOpacity, MaxOpacity);
        Renderer.color = color;

        var size = DefaultScale * BaseSizeRate + DefaultScale * Mathf.Max(0f, distance - RayMargin) * AddSizeRate;
        Renderer.transform.localScale = new Vector3(size.x, size.y, Renderer.transform.localScale.z);
    }

#if UNITY_EDITOR
    private void OnValidate()
    {
        RayOriginTransform ??= transform.parent;
        Renderer ??= GetComponent<SpriteRenderer>();
    }
#endif
}